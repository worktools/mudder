
{}
  :about "|Machine-generated snapshot. Do not edit directly — changes will be overwritten. Use `calcit query` to inspect and `calcit edit`/`calcit tree` to modify. Run `calcit docs agents --contract` before mutations; use `--full` for first orientation or changed contract digest. Manual edits must follow format and schema conventions, then run `calcit edit format`."
  :package |app
  :entries $ {} $ :default
    {} (:description |) (:init-fn 'app.main/main!) (:mode :js) (:reload-fn 'app.main/reload!) (:target :browser)
      :feature-policy $ {}
      :modules $ [] |respo.calcit/ |respo-ui.calcit/ |reel.calcit/ |alerts.calcit/
      :type-slots $ {}
  :files $ {}
    'app.comp.container $ %{} 'FileEntry
      :defs $ {}
        'comp-container $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defcomp comp-container (reel)
            let
                store $ :store reel
                states $ :states store
                prompt-plugin $ use-prompt (>> states :prompt)
                  {} (:text "|Add Swagger JSON here") (:multiline? true)
                    :input-style $ {} (:height |50vh) (:font-family ui/font-code)
                    :card-style $ {} $ :max-width |60vw
                focus $ :focus store
                api-data $ schema/optional-value $ :api-data store
              div
                {} $ :style $ merge ui/global ui/fullscreen ui/row
                div
                  {} $ :style $ merge ui/expand ui/column
                    {} $ :padding "|20px 20px"
                  div ({})
                    comp-json-block api-data ([]) focus
                  =< nil 200
                div
                  {} $ :style $ {} (:padding "|4px 8px")
                  div ({})
                    button $ {} (:style ui/button) (:inner-text |Load)
                      :on-click $ fn (e d!)
                        ; println $ :content state
                        .show prompt-plugin d! $ fn (text)
                          d! $ schema/Op :api-data $ decode-map-as
                            to-calcit-data $ js/JSON.parse text
                            :: 'Map 'String 'Dynamic
                    =< 8 nil
                    button $ {} (:style ui/button) (:inner-text |Reset)
                      :on-click $ fn (e d!)
                        d! $ schema/Op :reset
                    =< 24 nil
                    button $ {} (:style ui/button) (:inner-text |Array)
                      :on-click $ fn (e d!)
                        d! $ schema/Op :wrap-array
                    =< 8 nil
                    button $ {} (:style ui/button) (:inner-text |Object)
                      :on-click $ fn (e d!)
                        d! $ schema/Op :wrap-object
                    =< 8 nil
                    button $ {} (:style ui/button) (:inner-text "|Set bool")
                      :on-click $ fn (e d!)
                        d! $ schema/Op :set-bool
                  =< 0 nil
                  div ({})
                    button $ {} (:style ui/button) (:inner-text "|Copy Text")
                      :on-click $ fn (e d!)
                        let
                            data $ to-js-data api-data
                          copy! $ js/JSON.stringify data nil 2
                          js/console.log |Copied data
                  =< 0 nil
                  div ({})
                    button $ {} (:style ui/button) (:inner-text "|Copy Tree")
                      :on-click $ fn (e d!)
                        d! $ schema/Op :copy
                    =< 4 nil
                    let
                        clipboard $ .unwrap-or (:clipboard store) nil
                      if (non-nil? clipboard)
                        <>
                          decode-map-as
                            .unwrap-or (get clipboard |type) |
                            , 'String
                          {} (:font-family ui/font-fancy)
                            :color $ hsl 0 0 70
                    =< 4 nil
                    button $ {} (:style ui/button) (:inner-text "|Paste Tree")
                      :on-click $ fn (e d!)
                        d! $ schema/Op :paste
                  =< 0 nil
                  comp-named (>> states :named) (:memory store)
                    .unwrap-or (get-in api-data focus) nil
                .render prompt-plugin
                when dev? $ comp-typed-reel (>> states :reel) reel $ {}
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'respo.schema/Component)
            :args $ [] $ :: 'reel.typed/State 'app.schema/Op 'app.schema/Store
            :features $ #{} :js-ffi
        'comp-json-block $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn comp-json-block (data path focus)
            let
                data $ if (nil? data) ({})
                  decode-map-as data $ :: 'Map 'String 'Dynamic
              case-default
                .unwrap-or (get data |type) nil
                div ({})
                  do (js/console.warn "|Unkown data" data)
                    <> $ str "|Unknown data: data"
                |object $ let
                    required-fields $ decode-map-as
                      .unwrap-or (get data |required) ([])
                      :: 'List 'String
                  div
                    {} $ :style $ merge style-block
                      {} $ :flex-direction :column
                      if (= path focus)
                        {} (:border-radius |8px)
                          :background-color $ hsl 0 0 97
                        {}
                    span $ {}
                      :style $ {} (:cursor :pointer) (:font-family ui/font-fancy)
                      :inner-text |Object
                      :on-click $ fn (e d!)
                        d! $ schema/Op :focus path
                    list->
                      {} $ :style $ {} (:margin-left 8)
                      let
                          properties $ decode-map-as
                            .unwrap-or (get data |properties) ({})
                            :: 'Map 'String 'Dynamic
                        map
                          .to-list $ keys properties
                          fn (k)
                            let
                                v $ .unwrap $ get properties k
                              [] k $ div
                                {} $ :style ui/row
                                div
                                  {} $ :style $ {} (:font-family ui/font-code)
                                    :color $ hsl 200 90 60
                                  if
                                    -> required-fields $ .includes? k
                                    <> |* $ {} $ :color :red
                                  <> k
                                =< 8 nil
                                comp-json-block v
                                  conj (conj path |properties) k
                                  , focus
                |array $ div
                  {} $ :style $ merge ui/row style-block
                    if (= path focus)
                      {} (:border-radius |8px)
                        :background-color $ hsl 0 0 97
                      {}
                  span $ {}
                    :style $ {} (:cursor :pointer) (:font-family ui/font-fancy)
                    :on-click $ fn (e d!)
                      d! $ schema/Op :focus path
                    :inner-text |Array
                  =< 8 nil
                  comp-json-block
                    .unwrap-or (get data |items) nil
                    conj path |items
                    , focus
                |string $ comp-literal data path $ = path focus
                |number $ comp-literal data path $ = path focus
                |integer $ comp-literal data path $ = path focus
                |boolean $ comp-literal data path $ = path focus
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'respo.schema/Element)
            :args $ [] 'Dynamic (:: 'List 'String) (:: 'List 'String)
            :features $ #{} :js-ffi
        'comp-literal $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn comp-literal (rule path focused?)
            div
              {} $ :style $ merge style-literal
                if focused?
                  {} (:border-radius |8px)
                    :background-color $ hsl 0 0 97
                  {}
              span $ {}
                :style $ {} $ :font-family ui/font-fancy
                :on-click $ fn (e d!)
                  d! $ schema/Op :focus path
                :inner-text $ .unwrap-or (get rule |type) nil
              match (get rule |mock)
                (:some mock)
                  span $ {}
                    :style $ {} (:margin-left 8) (:font-size 10) (:font-family ui/font-code)
                      :color $ hsl 200 40 70
                    :inner-text $ .unwrap-or (get mock |mock) nil
                (:none) nil
              match (get rule |description)
                (:some desc)
                  <> (decode-map-as desc 'String)
                    {} (:margin-left 8) (:font-size 12)
                      :color $ hsl 0 0 80
                (:none) nil
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'respo.schema/Element)
            :args $ [] (:: 'Map 'String 'Dynamic) (:: 'List 'String) 'Bool
        'comp-named $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defcomp comp-named (states memory focus-data)
            let
                name-plugin $ use-prompt (>> states :name)
                  {} $ :text "|Name this item"
              div ({})
                div ({})
                  button $ {} (:style ui/button) (:inner-text |Save)
                    :on-click $ fn (e d!)
                      .show name-plugin d! $ fn (text)
                        d! $ schema/Op :save-item text focus-data
                list-> ({})
                  map
                    .to-list $ keys memory
                    fn (k)
                      let
                          item $ .unwrap $ get memory k
                        [] k $ div ({})
                          span $ {}
                            :style $ {} (:cursor :pointer) (:color :blue)
                            :inner-text k
                            :on-click $ fn (e d!)
                              d! $ schema/Op :paste-with item
                          =< 8 nil
                          span $ {}
                            :style $ {} (:cursor :pointer) (:color :red)
                            :on-click $ fn (e d!)
                              d! $ schema/Op :remove-item k
                            :inner-text "|✕"
                .render name-plugin
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'respo.schema/Component)
            :args $ [] (:: 'Map 'Dynamic 'Dynamic) (:: 'Map 'String 'Dynamic) 'Dynamic
        'style-block $ %{} 'CodeEntry (:doc |)
          :code $ quote $ def style-block
            {}
              :border-left $ str "|1px solid " $ hsl 0 0 90
              :padding-left 8
              :display :inline-flex
          :examples $ []
          :schema $ :: 'Map 'Tag 'Dynamic
        'style-literal $ %{} 'CodeEntry (:doc |)
          :code $ quote $ def style-literal
            {} (:cursor :pointer) (:padding "|2px 4px")
          :examples $ []
          :schema $ :: 'Map 'Tag 'Dynamic
      :ns $ %{} 'NsEntry (:doc |)
        :code $ quote $ ns app.comp.container
          :require (respo-ui.core :as ui)
            respo-ui.core :refer $ hsl
            respo.core :refer $ defcomp list-> <> >> div button span
            respo.comp.space :refer $ =<
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
          :schema $ :: 'Bool
        'site $ %{} 'CodeEntry (:doc |)
          :code $ quote $ def site
            {} $ :storage-key |workflow
          :examples $ []
          :schema $ :: 'Map 'Tag 'String
      :ns $ %{} 'NsEntry (:doc |)
        :code $ quote $ ns app.config
    'app.main $ %{} 'FileEntry
      :defs $ {}
        '*reel $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defref *reel
            %{} typed/State (:base schema/store) (:store schema/store)
              :records $ []
              :pointer $ Option :none
              :stopped? false
              :display? false
              :merged? false
          :examples $ []
          :schema $ :: 'Ref $ :: 'reel.typed/State 'app.schema/Op 'app.schema/Store
        '*storage-ready? $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defref *storage-ready? false
          :examples $ []
          :schema $ :: 'Ref 'Bool
        'dispatch! $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn dispatch! (op)
            when config/dev? $ println |Dispatch: op
            if (enum? op)
              match (typed/decode-control op)
                (:some control)
                  reset! *reel $ typed/apply-control updater @*reel control
                (:none)
                  reset! *reel $ typed/record-op updater @*reel (schema/normalize-op op) (generate-id!) (host/now-ms)
              raise "|Expected an operation Enum"
            , &unit
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'Unit)
            :args $ [] 'Dynamic
        'main! $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn main! ()
            println "|Running mode:" $ if config/dev? |dev |release
            when config/dev? $ load-console-formatter!
            render-app!
            add-watch! *reel :changes $ fn (reel prev) (render-app!)
            when config/dev? $ listen-devtools! |k dispatch!
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
          :schema $ :: 'Fn $ {} (:return 'Unit)
            :args $ []
            :features $ #{} :js-ffi
        'mount-target $ %{} 'CodeEntry (:doc |)
          :code $ quote $ def mount-target
            .unwrap $ dom/query-selector |.app
          :examples $ []
          :schema $ :: 'respo.dom/DomElement
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
          :schema $ :: 'Fn $ {} (:return 'Unit)
            :args $ []
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
          :schema $ :: 'Fn $ {} (:return 'Unit)
            :args $ []
            :features $ #{} :js-ffi
        'render-app! $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn render-app! ()
            render-with! mount-target
              fn () $ comp-container @*reel
              , dispatch!
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'Unit)
            :args $ []
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
        'Op $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defenum Op
            :states (:: 'List 'Dynamic) 'Dynamic
            :api-data $ :: 'Map 'String 'Dynamic
            :reset
            :wrap-object
            :wrap-array
            :set-bool
            :copy
            :paste
            :focus $ :: 'List 'String
            :paste-with 'Dynamic
            :save-item 'String 'Dynamic
            :remove-item 'String
            :hydrate-storage 'app.schema/Store
          :examples $ []
          :schema $ :: 'EnumDef
        'Store $ %{} 'CodeEntry
          :doc "|Root application state. Swagger values and heterogeneous Respo state remain honest open boundaries; extra preserves unknown legacy root fields."
          :code $ quote $ defstruct Store
            :states $ :: 'Map 'Dynamic 'Dynamic
            :api-data $ :: 'Option $ :: 'Map 'String 'Dynamic
            :version-0 $ :: 'Option $ :: 'Map 'String 'Dynamic
            :focus $ :: 'List 'String
            :clipboard $ :: 'Option 'Dynamic
            :memory $ :: 'Map 'String 'Dynamic
            :extra $ :: 'Map 'Tag 'Dynamic
          :examples $ []
          :schema $ :: 'StructDef
          :tests $ []
            %{} 'TestEntry (:name |legacy-extra-fields-and-memory)
              :code $ quote $ let
                  raw $ assoc
                    assoc (serialize-store store) :custom $ {} $ :retained true
                    , :memory $ {} (|empty nil) (|boolean false)
                  checked $ decode-store raw
                assert= raw $ serialize-store checked
                assert= (Option :none) (:api-data checked)
                assert= (Option :some false)
                  get (:memory checked) |boolean
              :tags $ #{} :unit
            %{} 'TestEntry (:name |rejects-malformed-focus)
              :code $ quote $ assert |invalid-focus-rejected
                try
                  do
                    decode-store $ assoc (serialize-store store) :focus $ [] 7
                    , false
                  fn (message)
                    hint-fn $ {}
                      :args $ [] 'String
                      :return 'Bool
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
        'decode-store $ %{} 'CodeEntry
          :doc "|Validate the existing flat Map archive and construct the current Store. Persistence retains the legacy Map format."
          :code $ quote $ defn decode-store (raw)
            let
                fields $ decode-map-as raw $ :: 'Map 'Tag 'Dynamic
                clipboard $ .unwrap-or (get fields :clipboard) nil
              Store :states
                decode-map-as
                  .unwrap-or (get fields :states) ({})
                  :: 'Map 'Dynamic 'Dynamic
                , :api-data
                  optional-schema $ .unwrap-or (get fields :api-data) nil
                  , :version-0
                    optional-schema $ .unwrap-or (get fields :version-0) nil
                    , :focus
                      decode-map-as
                        .unwrap-or (get fields :focus) ([])
                        :: 'List 'String
                      , :clipboard
                        if (nil? clipboard) (Option :none) (Option :some clipboard)
                        , :memory
                          decode-map-as
                            .unwrap-or (get fields :memory) ({})
                            :: 'Map 'String 'Dynamic
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
          :schema $ :: 'Fn $ {} (:return 'app.schema/Store)
            :args $ [] 'Dynamic
        'normalize-op $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn normalize-op (op)
            match op
              (:states cursor data)
                Op :states
                  decode-map-as cursor $ :: 'List 'Dynamic
                  , data
              (:api-data data)
                Op :api-data $ decode-map-as data $ :: 'Map 'String 'Dynamic
              (:reset) (Op :reset)
              (:wrap-object) (Op :wrap-object)
              (:wrap-array) (Op :wrap-array)
              (:set-bool) (Op :set-bool)
              (:copy) (Op :copy)
              (:paste) (Op :paste)
              (:focus data)
                Op :focus $ decode-map-as data $ :: 'List 'String
              (:paste-with data) (Op :paste-with data)
              (:save-item name tree)
                Op :save-item (decode-map-as name 'String) tree
              (:remove-item data)
                Op :remove-item $ decode-map-as data 'String
              (:hydrate-storage data)
                Op :hydrate-storage $ if (struct? data)
                  struct-match data (Store stored stored)
                    _ _ $ raise "|Expected Store"
                  decode-store data
              _ $ raise |Unknown-operation
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'app.schema/Op)
            :args $ [] 'Enum
        'optional-schema $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn optional-schema (raw)
            if (nil? raw) (Option :none)
              Option :some $ decode-map-as raw $ :: 'Map 'String 'Dynamic
          :examples $ []
          :schema $ :: 'Fn $ {}
            :args $ [] 'Dynamic
            :return $ :: 'Option $ :: 'Map 'String 'Dynamic
        'optional-value $ %{} 'CodeEntry
          :doc "|Legacy storage serialization boundary: retain JSON/EDN nil for absent fields; business state uses Option."
          :code $ quote $ defn optional-value (value) (.unwrap-or value nil)
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'Dynamic)
            :args $ [] $ :: 'Option 'Dynamic
        'serialize-store $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn serialize-store (value)
            merge (:extra value)
              {}
                :states $ :states value
                :api-data $ optional-value $ :api-data value
                :version-0 $ optional-value $ :version-0 value
                :focus $ :focus value
                :clipboard $ optional-value $ :clipboard value
                :memory $ :memory value
          :examples $ []
          :schema $ :: 'Fn $ {}
            :args $ [] 'app.schema/Store
            :return $ :: 'Map 'Tag 'Dynamic
        'store $ %{} 'CodeEntry (:doc |)
          :code $ quote $ def store
            Store :states
              {} $ :cursor $ []
              , :api-data (Option :none) :version-0 (Option :none) :focus ([]) :clipboard (Option :none) :memory ({}) :extra $ {}
          :examples $ []
          :schema $ :: 'app.schema/Store
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
                  (:some value)
                    if (nil? value) (Option :none) (Option :some value)
                  (:none) (Option :none)
              (:none) (Option :none)
          :examples $ []
          :schema $ :: 'Fn $ {}
            :args $ [] 'app.schema/Store
            :return $ :: 'Option 'Dynamic
        'put-focus $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn put-focus (store value)
            let
                api $ .unwrap-or (:api-data store) ({})
                updated $ decode-map-as
                  assoc-in api (:focus store) value
                  :: 'Map 'String 'Dynamic
              struct-with store $ :api-data $ Option :some updated
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'app.schema/Store)
            :args $ [] 'app.schema/Store 'Dynamic
        'updater $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn updater (store op op-id op-time)
            match op
              (:states cursor data)
                struct-with store $ :states $ decode-map-as
                  update-state-tree (:states store) cursor data
                  :: 'Map 'Dynamic 'Dynamic
              (:api-data data)
                struct-with store
                  :api-data $ Option :some data
                  :version-0 $ Option :some data
              (:reset)
                struct-with store $ :api-data $ :version-0 store
              (:focus path)
                struct-with store $ :focus path
              (:wrap-object)
                put-focus store $ {} (|type |object)
                  |properties $ {} $ |data
                    .unwrap-or (focused-value store) nil
              (:wrap-array)
                put-focus store $ {} (|type |array)
                  |items $ .unwrap-or (focused-value store) nil
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
          :schema $ :: 'Fn $ {} (:return 'app.schema/Store)
            :args $ [] 'app.schema/Store 'app.schema/Op 'String 'Number
            :features $ #{} :js-ffi
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
                assert= (Option :some |array)
                  get-in
                    .unwrap $ :api-data wrapped
                    [] |properties |flag |type
                assert=
                  Option :some $ [] false nil
                  get-in
                    .unwrap $ :api-data wrapped
                    [] |properties |flag |items |x-extension
                assert= (:api-data wrapped) (:api-data pasted)
                assert= (Option :some source) (:api-data reset)
                assert= (Option :some nil)
                  get (:memory saved) |nullable
                assert= (Option :none)
                  get (:memory removed) |nullable
                assert= initial $ updater initial (app.schema/Op :paste) |empty 10
              :tags $ #{} :unit
            %{} 'TestEntry (:name |state-update-does-not-nest-store)
              :code $ quote $ let
                  initial app.schema/store
                  updated $ updater initial
                    app.schema/Op :states ([] :dialog |name)
                      {} $ :text |draft
                    , |state 1
                assert= (Option :some |draft)
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
                assert= (Option :none) (:clipboard copied)
                assert= copied $ updater copied (app.schema/Op :paste) |paste 4
              :tags $ #{} :unit
      :ns $ %{} 'NsEntry (:doc |)
        :code $ quote $ ns app.updater
          :require $ respo.cursor :refer $ update-state-tree
