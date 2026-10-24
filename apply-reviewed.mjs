import assert from 'node:assert/strict';
import {execFileSync} from 'node:child_process';
import {readFileSync,writeFileSync,mkdirSync} from 'node:fs';
assert.equal(process.env.GITHUB_ACTIONS,'true');
assert.equal(process.platform,'linux');
assert.equal(execFileSync('calcit',['-v'],{encoding:'utf8'}).trim(),'0.30.1');
const run=(...a)=>execFileSync('calcit',['calcit.cirru',...a],{encoding:'utf8',maxBuffer:48e6,stdio:['ignore','pipe','pipe']});
const blob=()=>execFileSync('git',['hash-object','calcit.cirru'],{encoding:'utf8'}).trim();
assert.equal(blob(),'e13d03e3fb80f510b45df5aa61bb3412c784c451');
const norm=v=>Array.isArray(v)?v.map(norm):v&&typeof v==='object'?Object.fromEntries(Object.entries(v).map(([k,x])=>[k,k==='__edn_set'?x.map(norm).sort((a,b)=>JSON.stringify(a).localeCompare(JSON.stringify(b))):norm(x)])):v;
const q=(...a)=>norm(JSON.parse(run('query',...a,'--format','json')).data);
const input=JSON.parse(readFileSync('reviewed.json','utf8'));
const before={config:norm(input.config.data),namespaces:input.namespaces.map(x=>norm(x.data)),defs:input.definitions.map(x=>norm(x.data))};
assert.equal(before.defs.length,29);assert.equal(before.namespaces.length,6);
assert.equal(before.defs.reduce((n,d)=>n+d.tests.length,0),6);
assert.deepEqual(q('config'),before.config);
assert.deepEqual(q('ns').namespaces.map(n=>q('ns',n)),before.namespaces);
for(const d of before.defs)assert.deepEqual(q('def',d.id),d);
const expected=structuredClone(before),ops=[],sites=[],counts={merge:0,css:0,schema:0,dom:0,prompt:0};
const producer=q('def','respo.schema/EventHandler');
const eventArgs=producer.schema.find(p=>Array.isArray(p)&&p[0]===':args')[1];
assert.deepEqual(eventArgs,['[]',['::',"'Map","'Tag","'Dynamic"],['::',"'Fn",['{}',[':rest',"'Dynamic"],[':return',"'Unit"],[':args',['[]',"'Dynamic"]]]]]);
const show=(id,path)=>JSON.parse(run('tree','show',id,'--path','@'+path.join('.'),'--format','json')).tree;
function replace(id,path,old,value){assert.deepEqual(show(id,path),old);ops.push(['tree','replace',id,'--path','@'+path.join('.'),'--input-format','json-ast','--code',JSON.stringify(value)]);sites.push({id,path,before:old,after:value});}
function walk(x,path,id){
  if(!Array.isArray(x)||['quote','quasiquote','comment',';','defmacro'].includes(x[0]))return x;
  if(x[0]==='fn'&&JSON.stringify(x[1])===JSON.stringify(['e','d!'])&&x.some(v=>Array.isArray(v)&&v[0]==='.show')){
    assert.ok(['app.comp.container/comp-container','app.comp.container/comp-named'].includes(id));
    const old=structuredClone(x),call=x.find(v=>Array.isArray(v)&&v[0]==='.show');
    assert.equal(call.length,4);assert.deepEqual(call[3].slice(0,2),['fn',['text']]);
    assert.equal(call[3].length,3);assert.equal(call[3][2][0],'d!');
    call[3].splice(2,0,['hint-fn',['{}',[':args',['[]',"'String"]],[':return',"'Unit"]]]);counts.prompt++;
    x.splice(2,0,['hint-fn',['{}',[':return',"'Unit"],[':args',structuredClone(eventArgs)]]]);
    replace(id,path,old,x);counts.dom++;return x;
  }
  if(x[0]==='merge'){
    assert.ok(id.startsWith('app.comp.container/')||id==='app.schema/serialize-store');
    assert.ok(x.length>=3);replace(id,[...path,0],'merge','.merge');x[0]='.merge';counts.merge++;
  }
  if(x[0]==='{}'&&id.startsWith('app.comp.container/'))for(let i=1;i<x.length;i++){
    const pair=x[i];if(!Array.isArray(pair)||pair.length!==2)continue;
    const[k,v]=pair;let value;
    if([':margin-left',':font-size',':padding-left'].includes(k)&&typeof v==='string'&&/^\d+$/.test(v))value='|'+v+'px';
    else if([':cursor',':color',':flex-direction',':display'].includes(k)&&typeof v==='string'&&v.startsWith(':'))value='|'+v.slice(1);
    if(value!==undefined){replace(id,[...path,i,1],v,value);pair[1]=value;counts.css++;}
  }
  return x.map((v,i)=>walk(v,[...path,i],id));
}
for(const d of expected.defs)d.code=walk(d.code,[],d.id);
for(const id of ['app.comp.container/style-block','app.comp.container/style-literal']){
  const d=expected.defs.find(d=>d.id===id);
  assert.deepEqual(d.schema,['::',"'Map","'Tag","'Dynamic"]);
  d.schema=['::',"'Map","'Tag","'String"];
  ops.push(['edit','schema',id,'--input-format','json-ast','--code',JSON.stringify(d.schema)]);counts.schema++;
}
assert.deepEqual(counts,{merge:6,css:16,schema:2,dom:2,prompt:2});assert.equal(ops.length,26);
for(const d of before.defs){
  const e=expected.defs.find(x=>x.id===d.id);
  for(const k of Object.keys(d).filter(k=>!['code','schema'].includes(k)))assert.deepEqual(e[k],d[k]);
  if(!['app.comp.container/style-block','app.comp.container/style-literal'].includes(d.id))assert.deepEqual(e.schema,d.schema);
  if(!d.id.startsWith('app.comp.container/')&&d.id!=='app.schema/serialize-store')assert.deepEqual(e.code,d.code);
}
mkdirSync('acceptance',{recursive:true});
for(const[name,value]of Object.entries({before,expected,producer,sites,counts,operations:ops}))writeFileSync('acceptance/'+name+'.json',JSON.stringify(value,null,2));
const txn=['edit','transaction','--file','acceptance/operations.json','--format','json'];
const preview=JSON.parse(run(...txn,'--dry-run'));assert.ok(preview.scoped_revision);
writeFileSync('acceptance/preview.json',JSON.stringify(preview,null,2));
writeFileSync('acceptance/applied.json',run(...txn,'--expect-revision',preview.scoped_revision));
const after={config:q('config'),namespaces:q('ns').namespaces.map(n=>q('ns',n)),defs:expected.defs.map(d=>q('def',d.id))};
assert.deepEqual(after,expected);
writeFileSync('acceptance/after.json',JSON.stringify(after,null,2));
writeFileSync('acceptance/snapshot-after-blob.txt',blob());
