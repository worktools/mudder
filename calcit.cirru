
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
                states $ decode-map-as
                  .unwrap-or (get store :states) nil
                  :: 'Map 'Tag 'Dynamic
                prompt-plugin $ use-prompt (>> states :prompt)
                  {} (:text "|Add Swagger JSON here") (:multiline? true)
                    :input-style $ {} (:height |50vh) (:font-family ui/font-code)
                    :card-style $ {} $ :max-width |60vw
                focus $ decode-map-as
                  .unwrap-or (get store :focus) nil
                  :: 'List 'String
                api-data $ .unwrap-or (get store :api-data) nil
              ; js/console.log focus
              js/console.log $ .unwrap-or (get-in api-data focus) nil
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
                          d! $ :: :api-data $ to-calcit-data (js/JSON.parse text)
                    =< 8 nil
                    button $ {} (:style ui/button) (:inner-text |Reset)
                      :on-click $ fn (e d!)
                        d! $ :: :reset
                    =< 24 nil
                    button $ {} (:style ui/button) (:inner-text |Array)
                      :on-click $ fn (e d!)
                        d! $ :: :wrap-array
                    =< 8 nil
                    button $ {} (:style ui/button) (:inner-text |Object)
                      :on-click $ fn (e d!)
                        d! $ :: :wrap-object
                    =< 8 nil
                    button $ {} (:style ui/button) (:inner-text "|Set bool")
                      :on-click $ fn (e d!)
                        d! $ :: :set-bool
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
                        d! $ :: :copy
                    =< 4 nil
                    let
                        clipboard $ .unwrap-or (get store :clipboard) nil
                      if (some? clipboard)
                        <>
                          .unwrap-or (get clipboard |type) nil
                          {} (:font-family ui/font-fancy)
                            :color $ hsl 0 0 70
                    =< 4 nil
                    button $ {} (:style ui/button) (:inner-text "|Paste Tree")
                      :on-click $ fn (e d!)
                        d! $ :: :paste
                  =< 0 nil
                  comp-named (>> states :named)
                    decode-map-as
                      .unwrap-or (get store :memory) nil
                      :: 'Map 'String 'Dynamic
                    .unwrap-or (get-in api-data focus) nil
                .render prompt-plugin
                when dev? $ comp-typed-reel (>> states :reel) reel $ {}
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'respo.schema/Component)
            :args $ [] $ :: 'reel.typed/State 'app.schema/Op (:: 'Map 'Tag 'Dynamic)
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
                      assert-type
                        if (= path focus)
                          {} (:border-radius |8px)
                            :background-color $ hsl 0 0 97
                          {}
                        :: 'Map 'Tag 'Dynamic
                    span $ {}
                      :style $ {} (:cursor :pointer) (:font-family ui/font-fancy)
                      :inner-text |Object
                      :on-click $ fn (e d!)
                        d! $ :: :focus path
                    list->
                      {} $ :style $ {} (:margin-left 8)
                      map
                        .to-list $ decode-map-as
                          .unwrap-or (get data |properties) ({})
                          :: 'Map 'String 'Dynamic
                        fn (pair)
                          hint-fn $ {}
                            :args $ [] $ :: 'List 'Dynamic
                            :return $ :: 'List 'Dynamic
                          let
                              k $ decode-map-as
                                .unwrap $ nth pair 0
                                , 'String
                              v $ .unwrap $ nth pair 1
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
                    assert-type
                      if (= path focus)
                        {} (:border-radius |8px)
                          :background-color $ hsl 0 0 97
                        {}
                      :: 'Map 'Tag 'Dynamic
                  span $ {}
                    :style $ {} (:cursor :pointer) (:font-family ui/font-fancy)
                    :on-click $ fn (e d!)
                      d! $ :: :focus path
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
                assert-type
                  if focused?
                    {} (:border-radius |8px)
                      :background-color $ hsl 0 0 97
                    {}
                  :: 'Map 'Tag 'Dynamic
              span $ {}
                :style $ {} $ :font-family ui/font-fancy
                :on-click $ fn (e d!)
                  d! $ :: :focus path
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
                  <> desc $ {} (:margin-left 8) (:font-size 12)
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
                        d! $ :: :save-item $ [] text focus-data
                list-> ({})
                  -> memory (.to-list)
                    map $ fn (entry)
                      let[] (k item) entry $ [] k $ div ({})
                        span $ {}
                          :style $ {} (:cursor :pointer) (:color :blue)
                          :inner-text k
                          :on-click $ fn (e d!)
                            d! $ :: :paste-with item
                        =< 8 nil
                        span $ {}
                          :style $ {} (:cursor :pointer) (:color :red)
                          :on-click $ fn (e d!)
                            d! $ :: :remove-item k
                          :inner-text "|✕"
                .render name-plugin
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'respo.schema/Component)
            :args $ [] (:: 'Map 'Tag 'Dynamic) (:: 'Map 'String 'Dynamic) 'Dynamic
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
            respo-ui.core :refer $ [] hsl
            respo.core :refer $ [] defcomp list-> <> >> div button span
            respo.comp.space :refer $ [] =<
            reel.comp.reel :refer $ [] comp-typed-reel
            app.config :refer $ [] dev?
            respo-alerts.core :refer $ [] use-prompt
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
          :code $ quote $ defatom *reel
            assert-type (typed/new-reel schema/store)
              :: 'reel.typed/State 'app.schema/Op $ :: 'Map 'Tag 'Dynamic
          :examples $ []
          :schema $ :: 'Ref $ :: 'reel.typed/State 'app.schema/Op (:: 'Map 'Tag 'Dynamic)
        'dispatch! $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn dispatch! (op)
            when config/dev? $ println |Dispatch: op
            match (typed/decode-control op)
              (:some control)
                reset! *reel $ typed/apply-control updater @*reel control
              (:none)
                reset! *reel $ typed/record-op updater @*reel (schema/normalize-op op) (generate-id!) (host/now-ms)
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'Unit)
            :args $ [] 'Enum
        'main! $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn main! ()
            println "|Running mode:" $ if config/dev? |dev |release
            if config/dev? $ load-console-formatter!
            render-app!
            add-watch *reel :changes $ fn (r p) (render-app!)
            listen-devtools! |k dispatch!
            browser/add-event-listener! |beforeunload $ fn (event) (persist-storage!)
            browser/set-interval! persist-storage! 60000
            match
              browser/storage-get $ option:unwrap $ get config/site :storage-key
              (:some raw)
                dispatch! $ :: :hydrate-storage $ parse-cirru-edn raw
              (:none) nil
            println "|App started."
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'Unit)
            :args $ []
            :features $ #{} :js-ffi
        'mount-target $ %{} 'CodeEntry (:doc |)
          :code $ quote $ def mount-target
            option:unwrap $ browser/query-selector |.app
          :examples $ []
          :schema $ :: 'js-ffi.browser/DomElementHost
        'persist-storage! $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn persist-storage! ()
            browser/storage-set!
              option:unwrap $ get config/site :storage-key
              format-cirru-edn $ :store @*reel
            println |persist
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'Unit)
            :args $ []
        'reload! $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn reload! ()
            if (js-nullish? build-errors)
              do (remove-watch *reel :changes) (clear-cache!)
                add-watch *reel :changes $ fn (reel prev) (render-app!)
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
            render! mount-target (comp-container @*reel) dispatch!
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'Unit)
            :args $ []
      :ns $ %{} 'NsEntry (:doc |)
        :code $ quote $ ns app.main
          :require
            respo.core :refer $ [] render! clear-cache!
            respo.util :refer $ [] generate-id!
            app.comp.container :refer $ [] comp-container
            app.updater :refer $ [] updater
            app.schema :as schema
            reel.util :refer $ [] listen-devtools!
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
            :hydrate-storage $ :: 'Map 'Tag 'Dynamic
          :examples $ []
          :schema $ :: 'EnumDef
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
              (:save-item data)
                let
                    pair $ decode-map-as data $ :: 'List 'Dynamic
                  Op :save-item
                    decode-map-as
                      .unwrap $ nth pair 0
                      , 'String
                    .unwrap $ nth pair 1
              (:remove-item data)
                Op :remove-item $ decode-map-as data 'String
              (:hydrate-storage data)
                Op :hydrate-storage $ decode-map-as data $ :: 'Map 'Tag 'Dynamic
              _ $ raise |Unknown-operation
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'app.schema/Op)
            :args $ [] 'Enum
        'store $ %{} 'CodeEntry (:doc |)
          :code $ quote $ def store
            {}
              :states $ {} $ :cursor ([])
              :api-data nil
              :version-0 nil
              :focus $ []
              :clipboard nil
              :memory $ {}
          :examples $ []
          :schema $ :: 'Map 'Tag 'Dynamic
      :ns $ %{} 'NsEntry (:doc |)
        :code $ quote $ ns app.schema
    'app.updater $ %{} 'FileEntry
      :defs $ {} $ 'updater
        %{} 'CodeEntry (:doc |)
          :code $ quote $ defn updater (store op op-id op-time)
            decode-map-as
              match op
                (:states cursor data) (update-states store cursor data)
                (:api-data data)
                  -> store (assoc :api-data data) (assoc :version-0 data)
                (:reset)
                  assoc store :api-data $ .unwrap-or (get store :version-0) nil
                (:focus data) (assoc store :focus data)
                (:wrap-object)
                  assoc store :api-data $ update-in
                    .unwrap-or (get store :api-data) nil
                    decode-map-as
                      .unwrap-or (get store :focus) nil
                      :: 'List 'String
                    fn (x)
                      {} (|type |object)
                        |properties $ {} $ |data x
                (:wrap-array)
                  assoc store :api-data $ update-in
                    .unwrap-or (get store :api-data) nil
                    decode-map-as
                      .unwrap-or (get store :focus) nil
                      :: 'List 'String
                    fn (x)
                      {} (|type |array) (|items x)
                (:set-bool)
                  assoc store :api-data $ assoc-in
                    .unwrap-or (get store :api-data) nil
                    decode-map-as
                      .unwrap-or (get store :focus) nil
                      :: 'List 'String
                    {} $ |type |boolean
                (:copy)
                  let
                      data $ .unwrap-or
                        get-in
                          .unwrap-or (get store :api-data) nil
                          decode-map-as
                            .unwrap-or (get store :focus) nil
                            :: 'List 'String
                        , nil
                    assoc store :clipboard data
                (:paste)
                  let
                      focus $ decode-map-as
                        .unwrap-or (get store :focus) nil
                        :: 'List 'String
                      item $ .unwrap-or (get store :clipboard) nil
                    if (some? item)
                      update store :api-data $ fn (api) (assoc-in api focus item)
                      , store
                (:paste-with data)
                  let
                      focus $ decode-map-as
                        .unwrap-or (get store :focus) nil
                        :: 'List 'String
                    if (some? data)
                      update store :api-data $ fn (api) (assoc-in api focus data)
                      , store
                (:save-item name tree)
                  assoc store :memory $ assoc
                    decode-map-as
                      .unwrap-or (get store :memory) nil
                      :: 'Map 'String 'Dynamic
                    , name tree
                (:remove-item data)
                  assoc store :memory $ dissoc
                    decode-map-as
                      .unwrap-or (get store :memory) nil
                      :: 'Map 'String 'Dynamic
                    , data
                (:hydrate-storage data) data
              :: 'Map 'Tag 'Dynamic
          :examples $ []
          :schema $ :: 'Fn $ {}
            :args $ [] (:: 'Map 'Tag 'Dynamic) 'app.schema/Op 'String 'Number
            :features $ #{} :js-ffi
            :return $ :: 'Map 'Tag 'Dynamic
      :ns $ %{} 'NsEntry (:doc |)
        :code $ quote $ ns app.updater
          :require $ respo.cursor :refer $ update-states
