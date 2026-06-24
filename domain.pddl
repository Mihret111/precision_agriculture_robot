(define (domain precision-agriculture-robot-q1)

  (:requirements :adl :typing :numeric-fluents)

  (:types
    robot
    plot
    waypoint
  )

  (:predicates
    ;; robot embodiment and topology
    (at ?r - robot ?w - waypoint)
    (adjacent ?from - waypoint ?to - waypoint)
    (plot-at ?p - plot ?w - waypoint)

    ;; stations
    (recharge-station-at ?w - waypoint)
    (refill-water-at ?w - waypoint)
    (refill-fertilizer-at ?w - waypoint)
    (refill-pesticide-at ?w - waypoint)
    (refill-growth-support-at ?w - waypoint)

    ;; sensing and diagnosis
    (inspected ?p - plot)
    (needs-water ?p - plot)
    (needs-fertilizer ?p - plot)
    (needs-pesticide ?p - plot)

    ;; plot conditions
    (moisture-low ?p - plot)
    (moisture-ok ?p - plot)

    (nutrient-low ?p - plot)
    (nutrient-ok ?p - plot)

    (pest-present ?p - plot)
    (pest-absent ?p - plot)

    (health-good ?p - plot)
    (health-stressed ?p - plot)

    ;; action history / completion
    (watered ?p - plot)
    (fertilized ?p - plot)
    (sprayed ?p - plot)
    (reported ?p - plot)

    ; observations
    (moisture-observed ?p - plot)
    (pest-observed ?p - plot)
    (nutrient-observed ?p - plot)

    ; soil quality : to decode harmful effects
    (soil-quality-good ?p - plot)
    (soil-quality-degraded ?p - plot)

    ;; modality-specific classification status
    (moisture-classified ?p - plot)
    (pest-classified ?p - plot)
    (nutrient-classified ?p - plot)
    (growth-classified ?p - plot)

    ;; explicit no-treatment decisions
    (water-not-needed ?p - plot)
    (pesticide-not-needed ?p - plot)
    (fertilizer-not-needed ?p - plot)
    (growth-support-not-needed ?p - plot)

    ;; delayed-growth condition
    (growth-delayed ?p - plot)
    (growth-normal ?p - plot)
    (growth-observed ?p - plot)
    (needs-growth-support ?p - plot)
    (growth-supported ?p - plot)


  )

  (:functions
    ;robot battery and consumable levels
    (battery-level ?r - robot)
    (water-level ?r - robot)
    (fertilizer-level ?r - robot)
    (pesticide-level ?r - robot)

    ;; costs
    (move-energy-cost ?from - waypoint ?to - waypoint)   ; energy cost for moving between waypoints 
    (inspect-energy-cost)
    (water-energy-cost)
    (fertilize-energy-cost)
    (spray-energy-cost)

    ; sensing energy costs
    (sense-moisture-energy-cost)
    (sense-pest-energy-cost)
    (sense-nutrient-energy-cost)

        ;; additional sensing and support costs
    (sense-growth-energy-cost)
    (growth-support-energy-cost)

    ;; treatment dose sizes
    (water-dose)
    (fertilizer-dose)
    (pesticide-dose)
    (growth-support-dose)

    ;; optional support consumable
    (growth-support-level ?r - robot)
  
    ;; maximum resource capacities
    (battery-capacity ?r - robot)
    (water-capacity ?r - robot)
    (fertilizer-capacity ?r - robot)
    (pesticide-capacity ?r - robot)
    (growth-support-capacity ?r - robot)

  )
  ; move robot between adjacent waypoints, consuming battery energy
  (:action move
    :parameters (?r - robot ?from - waypoint ?to - waypoint)
    :precondition
      (and
        (at ?r ?from)
        (adjacent ?from ?to)
        (not (= ?from ?to))
        (>= (battery-level ?r) (move-energy-cost ?from ?to))
      )
    :effect
      (and
        (not (at ?r ?from))
        (at ?r ?to)
        (decrease (battery-level ?r) (move-energy-cost ?from ?to))
      )
  )
  ; inspect plot to determine conditions, consuming battery energy
  (:action inspect-plot
    :parameters (?r - robot ?p - plot ?w - waypoint)
    :precondition
      (and
        (at ?r ?w)
        (plot-at ?p ?w)
        (not (inspected ?p))
        (>= (battery-level ?r) (inspect-energy-cost))
      )
    :effect
      (and
        (inspected ?p)
        (decrease (battery-level ?r) (inspect-energy-cost))
      )
  )
  ; diagnose water need based on inspection results, no energy cost
  (:action diagnose-water-need
    :parameters (?p - plot)
    :precondition
      (and
        (inspected ?p)
        (moisture-observed ?p)
        (moisture-low ?p)
        (not (moisture-classified ?p))
      )
    :effect
      (and
        (needs-water ?p)
        (moisture-classified ?p)
      )
  )

  (:action diagnose-water-not-needed
    :parameters (?p - plot)
    :precondition
      (and
        (inspected ?p)
        (moisture-observed ?p)
        (moisture-ok ?p)
        (not (moisture-classified ?p))
      )
    :effect
      (and
        (water-not-needed ?p)
        (moisture-classified ?p)
      )
  )

  ;sensing actions
  (:action observe-moisture
  :parameters (?r - robot ?p - plot ?w - waypoint)
  :precondition
    (and
      (at ?r ?w)
      (plot-at ?p ?w)
      (inspected ?p)
      (not (moisture-observed ?p))
      (>= (battery-level ?r) (sense-moisture-energy-cost))
    )
  :effect
    (and
      (moisture-observed ?p)
      (decrease (battery-level ?r) (sense-moisture-energy-cost))
    )
  )

  (:action observe-pests
  :parameters (?r - robot ?p - plot ?w - waypoint)
  :precondition
    (and
      (at ?r ?w)
      (plot-at ?p ?w)
      (inspected ?p)
      (not (pest-observed ?p))
      (>= (battery-level ?r) (sense-pest-energy-cost))
    )
  :effect
    (and
      (pest-observed ?p)
      (decrease (battery-level ?r) (sense-pest-energy-cost))
    )
  )

  (:action observe-nutrients
  :parameters (?r - robot ?p - plot ?w - waypoint)
  :precondition
    (and
      (at ?r ?w)
      (plot-at ?p ?w)
      (inspected ?p)
      (not (nutrient-observed ?p))
      (>= (battery-level ?r) (sense-nutrient-energy-cost))
    )
  :effect
    (and
      (nutrient-observed ?p)
      (decrease (battery-level ?r) (sense-nutrient-energy-cost))
    )
  )

  (:action observe-growth
  :parameters (?r - robot ?p - plot ?w - waypoint)
  :precondition
    (and
      (at ?r ?w)
      (plot-at ?p ?w)
      (inspected ?p)
      (not (growth-observed ?p))
      (>= (battery-level ?r) (sense-growth-energy-cost))
    )
  :effect
    (and
      (growth-observed ?p)
      (decrease (battery-level ?r) (sense-growth-energy-cost))
    )
)


  ; apply water to plot, improving moisture condition and consuming water and battery energy
  (:action water-plot
    :parameters (?r - robot ?p - plot ?w - waypoint)
    :precondition
      (and
        (at ?r ?w)
        (plot-at ?p ?w)
        (moisture-classified ?p)
        (>= (water-level ?r) (water-dose))
        (>= (battery-level ?r) (water-energy-cost))
      )
    :effect
      (and
        (decrease (water-level ?r) (water-dose))
        (decrease (battery-level ?r) (water-energy-cost))

        ;; correct targeted irrigation
        (when (and (needs-water ?p) (moisture-low ?p))
          (and
            (not (moisture-low ?p))
            (moisture-ok ?p)
            (not (needs-water ?p))
            (watered ?p)
          )
        )

        ;; excessive irrigation damages soil quality
        (when (water-not-needed ?p)
          (and
            (not (soil-quality-good ?p))
            (soil-quality-degraded ?p)
          )
        )
      )
  )

  ; diagnose fertilizer need based on inspection results, no energy cost
  (:action diagnose-pesticide-need
    :parameters (?p - plot)
    :precondition
      (and
        (inspected ?p)
        (pest-observed ?p)
        (pest-present ?p)
        (not (pest-classified ?p))
      )
    :effect
      (and
        (needs-pesticide ?p)
        (pest-classified ?p)
      )
  )

  (:action diagnose-pesticide-not-needed
    :parameters (?p - plot)
    :precondition
      (and
        (inspected ?p)
        (pest-observed ?p)
        (pest-absent ?p)
        (not (pest-classified ?p))
      )
    :effect
      (and
        (pesticide-not-needed ?p)
        (pest-classified ?p)
      )
  )

  ; apply pesticide to plot, improving pest condition and consuming pesticide and battery energy
  (:action spray-pesticide
    :parameters (?r - robot ?p - plot ?w - waypoint)
    :precondition
      (and
        (at ?r ?w)
        (plot-at ?p ?w)
        (pest-classified ?p)
        (>= (pesticide-level ?r) (pesticide-dose))
        (>= (battery-level ?r) (spray-energy-cost))
      )
    :effect
      (and
        (decrease (pesticide-level ?r) (pesticide-dose))
        (decrease (battery-level ?r) (spray-energy-cost))

        ;; correct targeted spraying
        (when (and (needs-pesticide ?p) (pest-present ?p))
          (and
            (not (pest-present ?p))
            (pest-absent ?p)
            (not (needs-pesticide ?p))
            (sprayed ?p)
          )
        )

        ;; unnecessary pesticide stresses the crop
        (when (pesticide-not-needed ?p)
          (and
            (not (health-good ?p))
            (health-stressed ?p)
          )
        )
      )
  )

  ; diagnose fertilizer need based on inspection results, no energy cost
  (:action diagnose-fertilizer-need
    :parameters (?p - plot)
    :precondition
      (and
        (inspected ?p)
        (nutrient-observed ?p)
        (nutrient-low ?p)
        (not (nutrient-classified ?p))
      )
    :effect
      (and
        (needs-fertilizer ?p)
        (nutrient-classified ?p)
      )
  )

  (:action diagnose-fertilizer-not-needed
    :parameters (?p - plot)
    :precondition
      (and
        (inspected ?p)
        (nutrient-observed ?p)
        (nutrient-ok ?p)
        (not (nutrient-classified ?p))
      )
    :effect
      (and
        (fertilizer-not-needed ?p)
        (nutrient-classified ?p)
      )
  )

; apply fertilizer to plot, improving nutrient condition and consuming fertilizer and battery energy
(:action fertilize-plot
  :parameters (?r - robot ?p - plot ?w - waypoint)
  :precondition
    (and
      (at ?r ?w)
      (plot-at ?p ?w)
      (nutrient-classified ?p)
      (>= (fertilizer-level ?r) (fertilizer-dose))
      (>= (battery-level ?r) (fertilize-energy-cost))
    )
  :effect
    (and
      (decrease (fertilizer-level ?r) (fertilizer-dose))
      (decrease (battery-level ?r) (fertilize-energy-cost))

      ;; successful fertilization only after primary stressors are resolved
      (when (and (needs-fertilizer ?p) (nutrient-low ?p)
                 (moisture-ok ?p) (pest-absent ?p))
        (and
          (not (nutrient-low ?p))
          (nutrient-ok ?p)
          (not (needs-fertilizer ?p))
          (fertilized ?p)
        )
      )

      ;; poor fertilization context stresses crop
      (when (or (fertilizer-not-needed ?p)
                (moisture-low ?p)
                (pest-present ?p))
        (and
          (not (health-good ?p))
          (health-stressed ?p)
        )
      )
    )
)

  ;;Growth diagnosis
  (:action diagnose-growth-support-need
    :parameters (?p - plot)
    :precondition
      (and
        (inspected ?p)
        (growth-observed ?p)
        (growth-delayed ?p)
        (not (growth-classified ?p))
      )
    :effect
      (and
        (needs-growth-support ?p)
        (growth-classified ?p)
      )
  )

  (:action diagnose-growth-support-not-needed
    :parameters (?p - plot)
    :precondition
      (and
        (inspected ?p)
        (growth-observed ?p)
        (growth-normal ?p)
        (not (growth-classified ?p))
      )
    :effect
      (and
        (growth-support-not-needed ?p)
        (growth-classified ?p)
      )
  )

(:action support-growth
  :parameters (?r - robot ?p - plot ?w - waypoint)
  :precondition
    (and
      (at ?r ?w)
      (plot-at ?p ?w)
      (growth-classified ?p)
      (>= (growth-support-level ?r) (growth-support-dose))
      (>= (battery-level ?r) (growth-support-energy-cost))
    )
  :effect
    (and
      (decrease (growth-support-level ?r) (growth-support-dose))
      (decrease (battery-level ?r) (growth-support-energy-cost))

      ;; growth support works only after primary stressors are acceptable
      (when (and (needs-growth-support ?p)
                 (moisture-ok ?p)
                 (pest-absent ?p)
                 (nutrient-ok ?p)
                 (health-good ?p))
        (and
          (not (growth-delayed ?p))
          (growth-normal ?p)
          (not (needs-growth-support ?p))
          (growth-supported ?p)
        )
      )

      ;; unnecessary or premature growth support stresses crop
      (when (or (growth-support-not-needed ?p)
                (moisture-low ?p)
                (pest-present ?p)
                (nutrient-low ?p))
        (and
          (not (health-good ?p))
          (health-stressed ?p)
        )
      )
    )
)


  ; report final plot status after all treatments are done, no energy cost
(:action report-plot-status
  :parameters (?r - robot ?p - plot ?w - waypoint)
  :precondition
    (and
      (at ?r ?w)
      (plot-at ?p ?w)

      (inspected ?p)

      (moisture-classified ?p)
      (pest-classified ?p)
      (nutrient-classified ?p)
      (growth-classified ?p)

      (moisture-ok ?p)
      (pest-absent ?p)
      (nutrient-ok ?p)
      (growth-normal ?p)

      (health-good ?p)
      (soil-quality-good ?p)

      (not (reported ?p))
    )
  :effect
    (reported ?p)
)
;; ================= Resourse related action ===============
(:action recharge-battery
  :parameters (?r - robot ?w - waypoint)
  :precondition
    (and
      (at ?r ?w)
      (recharge-station-at ?w)
      (< (battery-level ?r) (battery-capacity ?r))
    )
  :effect
    (assign (battery-level ?r) (battery-capacity ?r))
)

(:action refill-water
  :parameters (?r - robot ?w - waypoint)
  :precondition
    (and
      (at ?r ?w)
      (refill-water-at ?w)
      (< (water-level ?r) (water-capacity ?r))
    )
  :effect
    (assign (water-level ?r) (water-capacity ?r))
)

(:action refill-fertilizer
  :parameters (?r - robot ?w - waypoint)
  :precondition
    (and
      (at ?r ?w)
      (refill-fertilizer-at ?w)
      (< (fertilizer-level ?r) (fertilizer-capacity ?r))
    )
  :effect
    (assign (fertilizer-level ?r) (fertilizer-capacity ?r))
)

(:action refill-pesticide
  :parameters (?r - robot ?w - waypoint)
  :precondition
    (and
      (at ?r ?w)
      (refill-pesticide-at ?w)
      (< (pesticide-level ?r) (pesticide-capacity ?r))
    )
  :effect
    (assign (pesticide-level ?r) (pesticide-capacity ?r))
)

(:action refill-growth-support
  :parameters (?r - robot ?w - waypoint)
  :precondition
    (and
      (at ?r ?w)
      (refill-growth-support-at ?w)
      (< (growth-support-level ?r) (growth-support-capacity ?r))
    )
  :effect
    (assign (growth-support-level ?r) (growth-support-capacity ?r))
)
)