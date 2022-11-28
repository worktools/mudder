
{} (:package |app)
  :configs $ {} (:init-fn |app.main/main!) (:reload-fn |app.main/reload!) (:version |0.0.1)
    :modules $ [] |respo.calcit/ |lilac/ |memof/ |respo-ui.calcit/ |respo-markdown.calcit/ |reel.calcit/ |alerts.calcit/
  :entries $ {}
  :files $ {}
    |app.comp.container $ {}
      :defs $ {}
        |comp-container $ quote
          defcomp comp-container (reel)
            let
                store $ :store reel
                states $ :states store
                cursor $ or (:cursor states)
                    "\"\""
                    "\"\""
                    "\"\""
                    "\"\""
                state $ or (:data states)
                  {} $ :content "\""
                prompt-plugin $ use-prompt (>> states :prompt)
                  {} (:text "|Add Swagger JSON here") (:multiline? true)
                    :input-style $ {} (:height "\"50vh") (:font-family ui/font-code)
                    :card-style $ {} (:max-width "\"60vw")
                focus $ :focus store
                api-data $ :api-data store
              ; js/console.log focus
              js/console.log $ get-in api-data focus
              div
                {} $ :style (merge ui/global ui/fullscreen ui/row)
                div
                  {} $ :style
                    merge ui/expand ui/column $ {} (:padding "\"20px 20px")
                  div ({})
                    comp-json-block api-data ([]) focus
                  =< nil 200
                div
                  {} $ :style
                    {} $ :padding "\"4px 8px"
                  div ({})
                    button $ {} (:style ui/button) (:inner-text "\"Load")
                      :on-click $ fn (e d!)
                        ; println $ :content state
                        .show prompt-plugin d! $ fn (text)
                          d! :api-data $ to-calcit-data (js/JSON.parse text)
                    =< 8 nil
                    button $ {} (:style ui/button) (:inner-text "\"Reset")
                      :on-click $ fn (e d!) (d! :reset nil)
                    =< 24 nil
                    button $ {} (:style ui/button) (:inner-text "\"Array")
                      :on-click $ fn (e d!) (d! :wrap-array nil)
                    =< 8 nil
                    button $ {} (:style ui/button) (:inner-text "\"Object")
                      :on-click $ fn (e d!) (d! :wrap-object nil)
                    =< 8 nil
                    button $ {} (:style ui/button) (:inner-text "\"Set bool")
                      :on-click $ fn (e d!) (d! :set-bool nil)
                  =< 0 nil
                  div ({})
                    button $ {} (:style ui/button) (:inner-text "\"Copy Text")
                      :on-click $ fn (e d!)
                        let
                            data $ to-js-data api-data
                          copy! $ js/JSON.stringify data nil 2
                          js/console.log "\"Copied" data
                  =< 0 nil
                  div ({})
                    button $ {} (:style ui/button) (:inner-text "\"Copy Tree")
                      :on-click $ fn (e d!) (d! :copy nil)
                    =< 4 nil
                    if-let
                      clipboard $ :clipboard store
                      <> (get clipboard "\"type")
                        {} (:font-family ui/font-fancy)
                          :color $ hsl 0 0 70
                    =< 4 nil
                    button $ {} (:style ui/button) (:inner-text "\"Paste Tree")
                      :on-click $ fn (e d!) (d! :paste nil)
                  =< 0 nil
                  comp-named (>> states :named) (:memory store) (get-in api-data focus)
                .render prompt-plugin
                when dev? $ comp-reel (>> states :reel) reel ({})
        |comp-json-block $ quote
          defn comp-json-block (data path focus)
            case-default (get data "\"type")
              div ({})
                do (js/console.warn "\"Unkown data" data)
                  <> $ str "\"Unknown data: data"
              "\"object" $ let
                  required-fields $ get data "\"required"
                div
                  {} $ :style
                    merge style-block
                      {} $ :flex-direction :column
                      if (= path focus)
                        {} (:border-radius "\"8px")
                          :background-color $ hsl 0 0 97
                  span $ {}
                    :style $ {} (:cursor :pointer) (:font-family ui/font-fancy)
                    :inner-text "\"Object"
                    :on-click $ fn (e d!) (d! :focus path)
                  list->
                    {} $ :style
                      {} $ :margin-left 8
                    -> data (get "\"properties")
                      .map-list $ fn (pair )
                        let[] (k v) pair $ [] k
                          div
                            {} $ :style ui/row
                            div
                              {} $ :style
                                {} (:font-family ui/font-code)
                                  :color $ hsl 200 90 60
                              if
                                -> required-fields .to-list $ .includes? k
                                <> "\"*" $ {} (:color :red)
                              <> k
                            =< 8 nil
                            comp-json-block v (conj path "\"properties" k) focus
              "\"array" $ div
                {} $ :style
                  merge ui/row style-block $ if (= path focus)
                    {} (:border-radius "\"8px")
                      :background-color $ hsl 0 0 97
                span $ {}
                  :style $ {} (:cursor :pointer) (:font-family ui/font-fancy)
                  :on-click $ fn (e d!) (d! :focus path)
                  :inner-text "\"Array"
                =< 8 nil
                -> data (get "\"items")
                  comp-json-block (conj path "\"items") focus
              "\"string" $ comp-literal data path (= path focus)
              "\"number" $ comp-literal data path (= path focus)
              "\"integer" $ comp-literal data path (= path focus)
              "\"boolean" $ comp-literal data path (= path focus)
        |comp-literal $ quote
          defn comp-literal (rule path focused?)
            div
              {} $ :style
                merge style-literal $ if focused?
                  {} (:border-radius "\"8px")
                    :background-color $ hsl 0 0 97
              span $ {}
                :style $ {} (:font-family ui/font-fancy)
                :on-click $ fn (e d!) (d! :focus path)
                :inner-text $ get rule "\"type"
              if-let
                mock $ get rule "\"mock"
                span $ {}
                  :style $ {} (:margin-left 8) (:font-size 10) (:font-family ui/font-code)
                    :color $ hsl 200 40 70
                  :inner-text $ get mock "\"mock"
              if-let
                desc $ get rule "\"description"
                <> desc $ {} (:margin-left 8) (:font-size 12)
                  :color $ hsl 0 0 80
        |comp-named $ quote
          defcomp comp-named ( states memory focus-data)
            let
                name-plugin $ use-prompt (>> states :name)
                  {} $ :text "\"Name this item"
              div ({})
                div ({})
                  button $ {} (:style ui/button) (:inner-text "\"Save")
                    :on-click $ fn (e d!)
                      .show name-plugin d! $ fn (text)
                        d! :save-item $ [] text focus-data  
                list-> ({})
                  -> memory (.to-list)
                    map $ fn (entry)
                      let[] (k item) entry $ [] k
                        div ({})
                          span $ {}
                            :style $ {} (:cursor :pointer) (:color :blue)
                            :inner-text k
                            :on-click $ fn (e d!) (d! :paste-with item)
                          =< 8 nil
                          span $ {}
                            :style $ {} (:cursor :pointer) (:color :red)
                            :on-click $ fn (e d!) (d! :remove-item k)
                            :inner-text "\"✕"
                .render name-plugin
        |style-block $ quote
          def style-block $ {}
            :border-left $ str "\"1px solid " (hsl 0 0 90)
            :padding-left 8
            :display :inline-flex
        |style-literal $ quote
          def style-literal $ {} (:cursor :pointer) (:padding "\"2px 4px")
      :ns $ quote
        ns app.comp.container $ :require (respo-ui.core :as ui)
          respo-ui.core :refer $ hsl
          respo.core :refer $ defcomp defeffect list-> <> >> div button textarea span input
          respo.comp.space :refer $ =<
          reel.comp.reel :refer $ comp-reel
          respo-md.comp.md :refer $ comp-md
          app.config :refer $ dev?
          respo-alerts.core :refer $ use-alert use-prompt use-confirm
          "\"copy-text-to-clipboard" :default copy!
    |app.config $ {}
      :defs $ {}
        |dev? $ quote
          def dev? $ = "\"dev" (get-env "\"mode" "\"release")
        |site $ quote
          def site $ {} (:storage-key "\"workflow")
      :ns $ quote (ns app.config)
    |app.main $ {}
      :defs $ {}
        |*reel $ quote
          defatom *reel $ -> reel-schema/reel (assoc :base schema/store) (assoc :store schema/store)
        |dispatch! $ quote
          defn dispatch! (op op-data)
            when
              and config/dev? $ not= op :states
              println "\"Dispatch:" op
            reset! *reel $ reel-updater updater @*reel op op-data
        |main! $ quote
          defn main! ()
            println "\"Running mode:" $ if config/dev? "\"dev" "\"release"
            if config/dev? $ load-console-formatter!
            render-app!
            add-watch *reel :changes $ fn (reel prev) (render-app!)
            listen-devtools! |k dispatch!
            js/window.addEventListener |beforeunload $ fn (event) (persist-storage!)
            flipped js/setInterval 60000 persist-storage!
            let
                raw $ js/localStorage.getItem (:storage-key config/site)
              when (some? raw)
                dispatch! :hydrate-storage $ parse-cirru-edn raw
            println "|App started."
        |mount-target $ quote
          def mount-target $ .!querySelector js/document |.app
        |persist-storage! $ quote
          defn persist-storage! () (js/console.log "\"persist")
            js/localStorage.setItem (:storage-key config/site)
              format-cirru-edn $ :store @*reel
        |reload! $ quote
          defn reload! () $ if (nil? build-errors)
            do (remove-watch *reel :changes) (clear-cache!)
              add-watch *reel :changes $ fn (reel prev) (render-app!)
              reset! *reel $ refresh-reel @*reel schema/store updater
              hud! "\"ok~" "\"Ok"
            hud! "\"error" build-errors
        |render-app! $ quote
          defn render-app! () $ render! mount-target (comp-container @*reel) dispatch!
      :ns $ quote
        ns app.main $ :require
          respo.core :refer $ render! clear-cache!
          app.comp.container :refer $ comp-container
          app.updater :refer $ updater
          app.schema :as schema
          reel.util :refer $ listen-devtools!
          reel.core :refer $ reel-updater refresh-reel
          reel.schema :as reel-schema
          app.config :as config
          "\"./calcit.build-errors" :default build-errors
          "\"bottom-tip" :default hud!
    |app.schema $ {}
      :defs $ {}
        |store $ quote
          def store $ {}
            :states $ {}
              :cursor $ []
            :api-data nil
            :version-0 nil
            :focus $ []
            :clipboard nil
            :memory $ {}
      :ns $ quote (ns app.schema)
    |app.updater $ {}
      :defs $ {}
        |updater $ quote
          defn updater (store op data op-id op-time)
            case-default op
              do (println "\"unknown op:" op) store
              :states $ update-states store data
              :api-data $ -> store (assoc :api-data data) (assoc :version-0 data)
              :reset $ assoc store :api-data (:version-0 store)
              :focus $ assoc store :focus data
              :wrap-object $ update-in store
                prepend (:focus store) :api-data
                fn (x)
                  {} ("\"type" "\"object")
                    "\"properties" $ {} ("\"data" x)
              :wrap-array $ update-in store
                prepend (:focus store) :api-data
                fn (x)
                  {} ("\"type" "\"array") ("\"items" x)
              :set-bool $ assoc-in store
                prepend (:focus store) :api-data
                {} $ "\"type" "\"boolean"
              :copy $ let
                  data $ get-in (:api-data store) (:focus store)
                assoc store :clipboard data
              :paste $ let
                  focus $ :focus store
                  item $ :clipboard store
                if (some? item)
                  update store :api-data $ fn (api) (assoc-in api focus item)
                  , store
              :paste-with $ let
                  focus $ :focus store
                if (some? data)
                  update store :api-data $ fn (api) (assoc-in api focus data)
                  , store
              :save-item $ let[] (name tree) data
                assoc-in store ([] :memory name) tree
              :remove-item $ dissoc-in store ([] :memory data)
              :hydrate-storage data
      :ns $ quote
        ns app.updater $ :require
          respo.cursor :refer $ update-states
