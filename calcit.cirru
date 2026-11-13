
{}
  :about "|Machine-generated snapshot. Do not edit directly — changes will be overwritten. Use `calcit query` to inspect and `calcit edit`/`calcit tree` to modify. Run `calcit docs agents --contract` before mutations; use `--full` for first orientation or changed contract digest. Manual edits must follow format and schema conventions, then run `calcit edit format`."
  :package |app
  :entries $ {} $ :default
    {} (:description |) (:init-fn 'app.main/main!) (:mode :js) (:reload-fn 'app.main/reload!) (:target :browser)
      :feature-policy $ {}
      :modules $ [] |respo.calcit/ |respo-ui.calcit/ |reel.calcit/ |alerts.calcit/
      :type-slots $ {} $ :dispatch-op 'app.schema/Op
  :files $ {}
    'app.comp.container $ %{} 'FileEntry
      :defs $ {}
        'comp-container $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defcomp comp-container (reel on-control on-op)
            let
                store $ :store reel
                states $ :states store
                prompt-plugin $ use-prompt (>> states :prompt)
                  {} (:text "|Add Swagger JSON here") (:multiline? true)
                    :input-style $ {} (:height |50vh) (:font-family ui/font-code)
                    :card-style $ {} $ :max-width |60vw
                focus $ :focus store
                api-data $ :api-data store
              div
                {} $ :style $ .merge ui/global ui/fullscreen ui/row
                div
                  {} $ :style $ .merge ui/expand ui/column
                    {} $ :padding "|20px 20px"
                  div ({})
                    match api-data
                      (:some data)
                        comp-json-block data ([]) focus
                      (:none) (<> "|Load a Swagger schema to begin.")
                  space-y 200
                div
                  {} $ :style $ {} (:padding "|4px 8px")
                  div ({})
                    button $ {} (:style ui/button) (:inner-text |Load)
                      :on-click $ fn (e d!)
                        hint-fn $ Fn respo.schema/RespoEvent
                          Fn *dispatch-op $ -> Unit
                          -> Unit
                        ; println $ :content state
                        .show prompt-plugin d! $ fn (text)
                          hint-fn $ Fn String $ -> Unit
                          on-op $ schema/Op :api-data $ decode-map-as
                            to-calcit-data $ js/JSON.parse text
                            Map String Dynamic
                        , &unit
                    space-x 8
                    button $ {} (:style ui/button) (:inner-text |Reset)
                      :on-click $ fn (e d!)
                        d! $ schema/Op :reset
                    space-x 24
                    button $ {} (:style ui/button) (:inner-text |Array)
                      :on-click $ fn (e d!)
                        d! $ schema/Op :wrap-array
                    space-x 8
                    button $ {} (:style ui/button) (:inner-text |Object)
                      :on-click $ fn (e d!)
                        d! $ schema/Op :wrap-object
                    space-x 8
                    button $ {} (:style ui/button) (:inner-text "|Set bool")
                      :on-click $ fn (e d!)
                        d! $ schema/Op :set-bool
                  space-x 0
                  div ({})
                    button $ {} (:style ui/button) (:inner-text "|Copy Text")
                      :on-click $ fn (e d!)
                        let
                            data $ match api-data
                              (:some data) (to-js-data data)
                              (:none) (to-js-data nil)
                          copy! $ js/JSON.stringify data nil 2
                          js/console.log |Copied data
                  space-x 0
                  div ({})
                    button $ {} (:style ui/button) (:inner-text "|Copy Tree")
                      :on-click $ fn (e d!)
                        d! $ schema/Op :copy
                    space-x 4
                    match (:clipboard store)
                      (:some clipboard)
                        if (non-nil? clipboard)
                          Some $ <>
                            decode-map-as
                              .unwrap-or (get clipboard |type) |
                              , 'String
                            {} (:font-family ui/font-fancy)
                              :color $ hsl 0 0 70
                          , None
                      (:none) None
                    space-x 4
                    button $ {} (:style ui/button) (:inner-text "|Paste Tree")
                      :on-click $ fn (e d!)
                        d! $ schema/Op :paste
                  space-x 0
                  comp-named (>> states :named) (:memory store) (app.updater/focused-value store) on-op
                .render prompt-plugin
                if dev?
                  Some $ comp-typed-reel (>> states :reel) reel ({}) on-control
                  , None
          :examples $ []
          :schema $ quote $ Fn (reel.typed/State schema/Op schema/Store)
            Fn reel.typed/Control $ -> Unit
            Fn schema/Op $ -> Unit
            -> respo.schema/Component
            :features :js-ffi
        'comp-json-block $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn comp-json-block (data path focus)
            match
              .unwrap-or (get data |type) |
              |object $ let
                  required-fields $ decode-map-as
                    .unwrap-or (get data |required) ([])
                    List String
                div
                  {} $ :style $ .merge style-block
                    {} $ :flex-direction |column
                    if (= path focus)
                      {} (:border-radius |8px)
                        :background-color $ hsl 0 0 97
                      {}
                  span $ {}
                    :style $ {} (:cursor |pointer) (:font-family ui/font-fancy)
                    :inner-text |Object
                    :on-click $ fn (e d!)
                      d! $ schema/Op :focus path
                  keyed->
                    {} $ :style $ {} (:margin-left |8px)
                    let
                        properties $ decode-map-as
                          .unwrap-or (get data |properties) ({})
                          Map String Dynamic
                      map
                        .to-list $ keys properties
                        fn (k)
                          let
                              v $ .unwrap $ get properties k
                            keyed-element k $ div
                              {} $ :style ui/row
                              div
                                {} $ :style $ {} (:font-family ui/font-code)
                                  :color $ hsl 200 90 60
                                if
                                  -> required-fields $ .includes? k
                                  Some $ <> |* $ {} (:color |red)
                                  , None
                                <> k
                              space-x 8
                              comp-json-block
                                .unwrap-or
                                  schema/optional-schema $ Some v
                                  {}
                                conj (conj path |properties) k
                                , focus
              |array $ div
                {} $ :style $ .merge ui/row style-block
                  if (= path focus)
                    {} (:border-radius |8px)
                      :background-color $ hsl 0 0 97
                    {}
                span $ {}
                  :style $ {} (:cursor |pointer) (:font-family ui/font-fancy)
                  :on-click $ fn (e d!)
                    d! $ schema/Op :focus path
                  :inner-text |Array
                space-x 8
                comp-json-block
                  .unwrap-or
                    schema/optional-schema $ get data |items
                    {}
                  conj path |items
                  , focus
              |string $ comp-literal data path $ = path focus
              |number $ comp-literal data path $ = path focus
              |integer $ comp-literal data path $ = path focus
              |boolean $ comp-literal data path $ = path focus
              _ $ div ({})
                do (js/console.warn "|Unkown data" data)
                  <> $ str "|Unknown data: data"
          :examples $ []
          :schema $ quote $ Fn (Map String Dynamic) (List String) (List String) (-> respo.schema/Element) (:features :js-ffi)
        'comp-literal $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn comp-literal (rule path focused?)
            div
              {} $ :style $ .merge style-literal
                if focused?
                  {} (:border-radius |8px)
                    :background-color $ hsl 0 0 97
                  {}
              span $ schema/assoc-wire-field
                {}
                  :style $ {} $ :font-family ui/font-fancy
                  :on-click $ fn (e d!)
                    d! $ schema/Op :focus path
                , :inner-text $ get rule |type
              match (get rule |mock)
                (:some mock)
                  Some $ span $ schema/assoc-wire-field
                    {} $ :style $ {} (:margin-left |8px) (:font-size |10px) (:font-family ui/font-code)
                      :color $ hsl 200 40 70
                    , :inner-text (get mock |mock)
                (:none) None
              match (get rule |description)
                (:some desc)
                  Some $ <> (decode-map-as desc 'String)
                    {} (:margin-left |8px) (:font-size |12px)
                      :color $ hsl 0 0 80
                (:none) None
          :examples $ []
          :schema $ quote $ Fn (Map String V) (List String) Bool (-> respo.schema/Element) (:generics V)
        'comp-named $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defcomp comp-named (states memory focus-data on-op)
            let
                name-plugin $ use-prompt (>> states :name)
                  {} $ :text "|Name this item"
              div ({})
                div ({})
                  button $ {} (:style ui/button) (:inner-text |Save)
                    :on-click $ fn (e d!)
                      hint-fn $ Fn respo.schema/RespoEvent
                        Fn *dispatch-op $ -> Unit
                        -> Unit
                      .show name-plugin d! $ fn (text)
                        hint-fn $ Fn String $ -> Unit
                        match focus-data
                          (:some item)
                            on-op $ schema/Op :save-item text item
                          (:none)
                            on-op $ schema/Op :save-item text nil
                      , &unit
                keyed-> ({})
                  map
                    .to-list $ keys memory
                    fn (k)
                      let
                          item $ .unwrap $ get memory k
                        keyed-element k $ div ({})
                          span $ {}
                            :style $ {} (:cursor |pointer) (:color |blue)
                            :inner-text k
                            :on-click $ fn (e d!)
                              d! $ schema/Op :paste-with item
                          space-x 8
                          span $ {}
                            :style $ {} (:cursor |pointer) (:color |red)
                            :on-click $ fn (e d!)
                              d! $ schema/Op :remove-item k
                            :inner-text "|✕"
                .render name-plugin
          :examples $ []
          :schema $ quote $ Fn respo.schema/States (Map String M) (Option F)
            Fn schema/Op $ -> Unit
            -> respo.schema/Component
            :generics M F
        'style-block $ %{} 'CodeEntry (:doc |)
          :code $ quote $ def style-block
            {}
              :border-left $ str "|1px solid " $ hsl 0 0 90
              :padding-left |8px
              :display |inline-flex
          :examples $ []
          :schema $ quote $ Map Tag String
        'style-literal $ %{} 'CodeEntry (:doc |)
          :code $ quote $ def style-literal
            {} (:cursor |pointer) (:padding "|2px 4px")
          :examples $ []
          :schema $ quote $ Map Tag String
      :ns $ %{} 'NsEntry (:doc |)
        :code $ quote $ ns app.comp.container
          :require (respo-ui.core :as ui)
            respo-ui.core :refer $ hsl
            respo.core :refer $ defcomp keyed-> keyed-element <> >> div button span
            respo.comp.space :refer $ space-x space-y
            reel.comp.reel :refer $ comp-typed-reel
            app.config :refer $ dev?
            respo-alerts.core :refer $ use-prompt
            app.schema :as schema
            |copy-text-to-clipboard :default copy!
    'app.config $ %{} 'FileEntry
      :defs $ {}
        'dev? $ %{} 'CodeEntry (:doc |)
          :code $ quote $ def dev?
            = |dev $ .unwrap-or (get-env |mode) |release
          :examples $ []
          :schema $ quote Bool
        'site $ %{} 'CodeEntry (:doc |)
          :code $ quote $ def site
            {} $ :storage-key |workflow
          :examples $ []
          :schema $ quote $ Map Tag String
      :ns $ %{} 'NsEntry (:doc |)
        :code $ quote $ ns app.config
    'app.main $ %{} 'FileEntry
      :defs $ {}
        '*reel $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defref *reel
            %{} typed/State (:base schema/store) (:store schema/store)
              :records $ []
              :pointer None
              :stopped? false
              :display? false
              :merged? false
          :examples $ []
          :schema $ quote $ Ref (typed/State schema/Op schema/Store)
        '*storage-ready? $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defref *storage-ready? false
          :examples $ []
          :schema $ quote $ Ref Bool
        'dispatch! $ %{} 'CodeEntry
          :doc "|Records a named application Op or applies a named Reel Control."
          :code $ quote $ defn dispatch! (op)
            when config/dev? $ println |Dispatch: op
            reset! *reel $ match op
              (reel.typed/Control control) (typed/apply-control updater @*reel control)
              (app.schema/Op action)
                typed/record-op updater @*reel action (generate-id!) (host/now-ms)
            , &unit
          :examples $ []
          :schema $ quote $ Fn schema/ResolvedOp (-> Unit) (:features :io :state)
        'main! $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn main! ()
            println "|Running mode:" $ if config/dev? |dev |release
            when config/dev? $ load-console-formatter!
            render-app!
            add-watch! *reel :changes $ fn (reel prev) (render-app!)
            when config/dev? $ listen-devtools! |k on-control!
            browser/add-event-listener! |beforeunload $ fn (event) (persist-storage!)
            browser/set-interval! persist-storage! 60000
            try
              do
                match
                  browser/storage-get $ .unwrap $ get config/site :storage-key
                  (:some raw)
                    dispatch! $ schema/Op :hydrate-storage $ schema/decode-store (parse-cirru-edn raw)
                  (:none) &unit
                reset! *storage-ready? true
              fn (message) (reset! *storage-ready? false)
                hud! |error $ str "|Restore failed; automatic saving is paused to protect saved data. " message
            println "|App started."
            , &unit
          :examples $ []
          :schema $ quote $ Fn (-> Unit) (:features :io :js-ffi :state)
        'mount-target $ %{} 'CodeEntry (:doc |)
          :code $ quote $ def mount-target
            .unwrap $ dom/query-selector |.app
          :examples $ []
          :schema $ quote respo.dom/DomElement
        'on-control! $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn on-control! (control) (dispatch! control)
          :examples $ []
          :schema $ quote $ Fn typed/Control (-> Unit) (:features :io :state)
        'persist-storage! $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn persist-storage! ()
            when @*storage-ready? $ try
              browser/storage-set!
                .unwrap $ get config/site :storage-key
                format-cirru-edn $ schema/serialize-store $ :store @*reel
              fn (message)
                hud! |error $ str "|Could not save locally: " message
            , &unit
          :examples $ []
          :schema $ quote $ Fn (-> Unit) (:features :state)
        'reload! $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn reload! ()
            if (js-nullish? build-errors)
              do (remove-watch! *reel :changes) (clear-cache!)
                add-watch! *reel :changes $ fn (reel prev) (render-app!)
                reset! *reel $ typed/refresh updater @*reel schema/store
                hud! |ok~ |Ok
              hud! |error build-errors
            println |Reloaded
          :examples $ []
          :schema $ quote $ Fn (-> Unit) (:features :io :js-ffi :state)
        'render-app! $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn render-app! ()
            render-with! mount-target
              fn () $ comp-container @*reel on-control! $ fn (op)
                hint-fn $ Fn schema/Op $ -> Unit
                dispatch! op
              fn (raw)
                hint-fn $ Fn *dispatch-op $ -> Unit
                dispatch! $ schema/normalize-op raw
          :examples $ []
          :schema $ quote $ Fn (-> Unit) (:features :io :state)
      :ns $ %{} 'NsEntry (:doc |)
        :code $ quote $ ns app.main
          :require
            respo.core :refer $ render-with! clear-cache!
            respo.ffi.browser :as dom
            app.comp.container :refer $ comp-container
            app.updater :refer $ updater
            app.schema :as schema
            reel.util :refer $ listen-devtools!
            reel.typed :as typed
            app.config :as config
            js-ffi.browser :as browser
            js-ffi.shared :as host
            |./calcit.build-errors :default build-errors
            |bottom-tip :default hud!
    'app.schema $ %{} 'FileEntry
      :defs $ {}
        'CursorKey $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defunion CursorKey Tag String Number
          :examples $ []
          :schema $ quote UnionDef
        'Op $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defenum Op
            :states (List app.schema/CursorKey) WidgetState
            :api-data $ Map String Dynamic
            :reset
            :wrap-object
            :wrap-array
            :set-bool
            :copy
            :paste
            :focus $ List String
            :paste-with Dynamic
            :save-item String Dynamic
            :remove-item String
            :hydrate-storage app.schema/Store
          :examples $ []
          :schema $ quote EnumDef
        'ResolvedOp $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defunion ResolvedOp Op reel.typed/Control
          :examples $ []
          :schema $ quote UnionDef
        'Store $ %{} 'CodeEntry
          :doc "|Root application state. Swagger values and heterogeneous Respo state remain honest open boundaries; extra preserves unknown legacy root fields."
          :code $ quote $ defstruct Store
            :states $ Map app.schema/CursorKey Dynamic
            :api-data $ Option $ Map String Dynamic
            :version-0 $ Option $ Map String Dynamic
            :focus $ List String
            :clipboard $ Option Dynamic
            :memory $ Map String Dynamic
            :extra $ Map Tag Dynamic
          :examples $ []
          :schema $ quote StructDef
          :tests $ []
            %{} 'TestEntry (:name |legacy-extra-fields-and-memory)
              :code $ quote $ let
                  raw $ assoc
                    assoc (serialize-store store) :custom $ {} $ :retained true
                    , :memory $ {} (|empty nil) (|boolean false)
                  checked $ decode-store raw
                assert= raw $ serialize-store checked
                assert= None $ :api-data checked
                assert= (Some false)
                  get (:memory checked) |boolean
              :tags $ #{} :unit
            %{} 'TestEntry (:name |rejects-malformed-focus)
              :code $ quote $ assert |invalid-focus-rejected
                try
                  do
                    decode-store $ assoc (serialize-store store) :focus $ [] 7
                    , false
                  fn (message)
                    hint-fn $ Fn String $ -> Bool
                    includes? message "|expected string"
              :tags $ #{} :unit
            %{} 'TestEntry (:name |saved-map-roundtrip)
              :code $ quote $ let
                  checked $ decode-store $ assoc (serialize-store store) :api-data
                    {} (|type |object)
                      |x-extension $ [] 1 false nil
                  archived $ parse-cirru-edn $ format-cirru-edn (serialize-store checked)
                  restored $ decode-store archived
                assert= (serialize-store checked) (serialize-store restored)
              :tags $ #{} :unit
            %{} 'TestEntry (:name |rejects-boolean-state-key)
              :code $ quote $ assert |reject-boolean-state-key
                try
                  do
                    decode-store $ assoc (serialize-store store) :states $ {} (true false)
                    , false
                  fn (message)
                    hint-fn $ Fn String $ -> Bool
                    includes? message |CursorKey
              :tags $ #{} :unit
        'WidgetField $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defunion WidgetField Bool String
          :examples $ []
          :schema $ quote UnionDef
        'WidgetState $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defunion WidgetState Bool (Map CursorKey WidgetField)
          :examples $ []
          :schema $ quote UnionDef
        'assoc-wire-field $ %{} 'CodeEntry
          :doc "|Write an optional value to the legacy wire Map, keeping an explicit nil for absent values."
          :code $ quote $ defn assoc-wire-field (target key value)
            match value
              (:some item) (.assoc target key item)
              (:none) (.assoc target key nil)
          :examples $ []
          :schema $ quote $ Fn (Map K Dynamic) K (Option T)
            -> $ Map K Dynamic
            :generics K T
        'decode-store $ %{} 'CodeEntry
          :doc "|Validate the existing flat Map archive and construct the current Store. Persistence retains the legacy Map format."
          :code $ quote $ defn decode-store (raw)
            let
                fields $ decode-map-as raw $ Map Tag Dynamic
              Store :states
                decode-map-as
                  .unwrap-or (get fields :states) ({})
                  Map app.schema/CursorKey Dynamic
                , :api-data
                  optional-schema $ get fields :api-data
                  , :version-0
                    optional-schema $ get fields :version-0
                    , :focus
                      decode-map-as
                        .unwrap-or (get fields :focus) ([])
                        List String
                      , :clipboard
                        match (get fields :clipboard)
                          (:some value)
                            if (nil? value) None $ Some value
                          (:none) None
                        , :memory
                          decode-map-as
                            .unwrap-or (get fields :memory) ({})
                            Map String Dynamic
                          , :extra $ dissoc
                            dissoc
                              dissoc
                                dissoc
                                  dissoc (dissoc fields :states) :api-data
                                  , :version-0
                                , :focus
                              , :clipboard
                            , :memory
          :examples $ []
          :schema $ quote $ Fn V (-> Store) (:generics V)
        'normalize-op $ %{} 'CodeEntry
          :doc "|Accept application Op values and adapt legacy widget state events."
          :code $ quote $ defn normalize-op (op)
            cond
                not $ enum? op
                raise |Unknown-operation
              (= (enum-definition op) (Some Op))
                decode-map-as op 'app.schema/Op
              true $ match op
                (:states cursor data)
                  Op :states
                    decode-map-as cursor $ List app.schema/CursorKey
                    decode-map-as data WidgetState
                _ $ raise |Unknown-operation
          :examples $ []
          :schema $ quote $ Fn Input (-> Op) (:generics Input) (:open :decode)
          :tests $ [] $ %{} 'TestEntry (:name |checked-state-cursor)
            :code $ quote $ let
                cursor $ [] :dialog |name 0
              assert= (Op :states cursor false)
                normalize-op $ :: :states cursor false
              assert |reject-bool-cursor $ try
                do
                  normalize-op $ :: :states ([] true) false
                  , false
                fn (message)
                  hint-fn $ Fn String $ -> Bool
                  includes? message |CursorKey
              assert= (Op :reset)
                normalize-op $ Op :reset
              assert |reject-anonymous-reset $ try
                do
                  normalize-op $ :: :reset
                  , false
                fn (message)
                  hint-fn $ Fn String $ -> Bool
                  = message |Unknown-operation
              assert |reject-non-enum $ try
                do (normalize-op |invalid) false
                fn (message)
                  hint-fn $ Fn String $ -> Bool
                  = message |Unknown-operation
            :tags $ #{} :unit
        'optional-schema $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn optional-schema (raw)
            match raw
              (:some value)
                if (nil? value) None $ Some $ decode-map-as value (Map String Dynamic)
              (:none) None
          :examples $ []
          :schema $ quote $ Fn (Option T)
            -> $ Option $ Map String Dynamic
            :generics T
        'serialize-store $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn serialize-store (value)
            app.schema/assoc-wire-field
              app.schema/assoc-wire-field
                app.schema/assoc-wire-field
                  .merge (:extra value)
                    {}
                      :states $ :states value
                      :focus $ :focus value
                      :memory $ :memory value
                  , :api-data $ :api-data value
                , :version-0 $ :version-0 value
              , :clipboard $ :clipboard value
          :examples $ []
          :schema $ quote $ Fn Store
            -> $ Map Tag Dynamic
        'store $ %{} 'CodeEntry (:doc |)
          :code $ quote $ def store
            Store :states
              {} $ :cursor $ []
              , :api-data None :version-0 None :focus ([]) :clipboard None :memory ({}) :extra $ {}
          :examples $ []
          :schema $ quote Store
      :ns $ %{} 'NsEntry (:doc |)
        :code $ quote $ ns app.schema
    'app.updater $ %{} 'FileEntry
      :defs $ {}
        'focused-value $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn focused-value (store)
            match (:api-data store)
              (:some api)
                match
                  get-in api $ :focus store
                  (:ok value)
                    if (nil? value) None $ Some value
                  (:err error)
                    match error
                      (:missing) None
                      (:shape message) (raise message)
              (:none) None
          :examples $ []
          :schema $ quote $ Fn app.schema/Store
            -> $ Option Dynamic
        'put-focus $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn put-focus (store value)
            let
                api $ .unwrap-or (:api-data store) ({})
                updated $ decode-map-as
                  assoc-in api (:focus store) value
                  Map String Dynamic
              struct-with store $ :api-data $ Some updated
          :examples $ []
          :schema $ quote $ Fn app.schema/Store V (-> app.schema/Store) (:generics V)
        'updater $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn updater (store op op-id op-time)
            match op
              (:states cursor data)
                struct-with store $ :states $ decode-map-as
                  update-state-tree (:states store) cursor data
                  Map app.schema/CursorKey Dynamic
              (:api-data data)
                struct-with store
                  :api-data $ Some data
                  :version-0 $ Some data
              (:reset)
                struct-with store $ :api-data $ :version-0 store
              (:focus path)
                struct-with store $ :focus path
              (:wrap-object)
                put-focus store $ {} (|type |object)
                  |properties $ app.schema/assoc-wire-field ({}) |data $ focused-value store
              (:wrap-array)
                put-focus store $ app.schema/assoc-wire-field
                  {} $ |type |array
                  , |items $ focused-value store
              (:set-bool)
                put-focus store $ {} $ |type |boolean
              (:copy)
                struct-with store $ :clipboard $ focused-value store
              (:paste)
                match (:clipboard store)
                  (:some item) (put-focus store item)
                  (:none) store
              (:paste-with data)
                if (nil? data) store $ put-focus store data
              (:save-item name tree)
                struct-with store $ :memory $ assoc (:memory store) name tree
              (:remove-item name)
                struct-with store $ :memory $ dissoc (:memory store) name
              (:hydrate-storage data) data
          :examples $ []
          :schema $ quote $ Fn app.schema/Store app.schema/Op String Number (-> app.schema/Store) (:features :js-ffi)
          :tests $ []
            %{} 'TestEntry (:name |focus-edit-copy-reset-and-memory)
              :code $ quote $ let
                  initial app.schema/store
                  source $ {} (|type |object)
                    |properties $ {} $ |flag
                      {} (|type |string)
                        |x-extension $ [] false nil
                  loaded $ updater initial (app.schema/Op :api-data source) |load 1
                  focused $ updater loaded
                    app.schema/Op :focus $ [] |properties |flag
                    , |focus 2
                  wrapped $ updater focused (app.schema/Op :wrap-array) |wrap 3
                  copied $ updater wrapped (app.schema/Op :copy) |copy 4
                  changed $ updater copied (app.schema/Op :set-bool) |bool 5
                  pasted $ updater changed (app.schema/Op :paste) |paste 6
                  reset $ updater pasted (app.schema/Op :reset) |reset 7
                  saved $ updater reset (app.schema/Op :save-item |nullable nil) |save 8
                  removed $ updater saved (app.schema/Op :remove-item |nullable) |remove 9
                assert= (Result :ok |array)
                  get-in
                    .unwrap $ :api-data wrapped
                    [] |properties |flag |type
                assert=
                  Result :ok $ [] false nil
                  get-in
                    .unwrap $ :api-data wrapped
                    [] |properties |flag |items |x-extension
                assert= (:api-data wrapped) (:api-data pasted)
                assert= (Some source) (:api-data reset)
                assert= (Some nil)
                  get (:memory saved) |nullable
                assert= None $ get (:memory removed) |nullable
                assert= initial $ updater initial (app.schema/Op :paste) |empty 10
              :tags $ #{} :unit
            %{} 'TestEntry (:name |state-update-does-not-nest-store)
              :code $ quote $ let
                  initial app.schema/store
                  updated $ updater initial
                    app.schema/Op :states ([] :dialog |name)
                      {} $ :text |draft
                    , |state 1
                assert= (Result :ok |draft)
                  get-in (:states updated) ([] :dialog |name :data :text)
                assert= false $ contains? (:states updated) :states
                assert= (:api-data initial) (:api-data updated)
              :tags $ #{} :unit
            %{} 'TestEntry (:name |copy-null-retains-empty-clipboard)
              :code $ quote $ let
                  loaded $ updater app.schema/store
                    app.schema/Op :api-data $ {} (|type |object) (|nullable nil)
                    , |load 1
                  focused $ updater loaded
                    app.schema/Op :focus $ [] |nullable
                    , |focus 2
                  copied $ updater focused (app.schema/Op :copy) |copy 3
                assert= None $ :clipboard copied
                assert= copied $ updater copied (app.schema/Op :paste) |paste 4
              :tags $ #{} :unit
      :ns $ %{} 'NsEntry (:doc |)
        :code $ quote $ ns app.updater
          :require $ respo.cursor :refer $ update-state-tree
