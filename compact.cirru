
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
              div
                {} $ :style (merge ui/global ui/column)
                div
                  {} $ :style
                    merge ui/expand $ {} (:padding "\"4px 8px")
                  button $ {} (:style ui/button) (:inner-text "\"Run")
                    :on-click $ fn (e d!)
                      println $ :content state
                      .show prompt-plugin d! $ fn (text)
                        d! :api-data $ to-calcit-data (js/JSON.parse text)
                div ({})
                  comp-json-block $ :api-data store
                .render prompt-plugin
                when dev? $ comp-reel (>> states :reel) reel ({})
        |comp-json-block $ quote
          defn comp-json-block (data) (; js/console.log data)
            case-default (get data "\"type")
              div ({})
                do (js/console.warn "\"Unkown data" data) (<> "\"Unknown data")
              "\"object" $ div
                {} $ :style style-block
                <> "\"object"
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
                            <> k
                          =< 8 nil
                          comp-json-block v
              "\"string" $ div ({}) (<> "\"string")
              "\"number" $ div ({}) (<> "\"number")
              "\"boolean" $ div ({}) (<> "\"boolean")
              "\"array" $ div
                {} $ :style (merge ui/row style-block)
                <> "\"array"
                =< 8 nil
                -> data (get "\"items") (comp-json-block)
        |style-block $ quote
          def style-block $ {}
            :border-left $ str "\"1px solid " (hsl 0 0 90)
            :padding-left 8
      :ns $ quote
        ns app.comp.container $ :require (respo-ui.core :as ui)
          respo-ui.core :refer $ hsl
          respo.core :refer $ defcomp defeffect list-> <> >> div button textarea span input
          respo.comp.space :refer $ =<
          reel.comp.reel :refer $ comp-reel
          respo-md.comp.md :refer $ comp-md
          app.config :refer $ dev?
          respo-alerts.core :refer $ use-alert use-prompt use-confirm
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
      :ns $ quote (ns app.schema)
    |app.updater $ {}
      :defs $ {}
        |updater $ quote
          defn updater (store op data op-id op-time)
            case-default op
              do (println "\"unknown op:" op) store
              :states $ update-states store data
              :api-data $ assoc store :api-data data
              :hydrate-storage data
      :ns $ quote
        ns app.updater $ :require
          respo.cursor :refer $ update-states
