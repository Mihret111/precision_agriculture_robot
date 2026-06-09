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
      (moisture-low ?p)
      (not (needs-water ?p))
    )
  :effect
    (needs-water ?p)
  )

  ; apply water to plot, improving moisture condition and consuming water and battery energy
  (:action water-plot
  :parameters (?r - robot ?p - plot ?w - waypoint)
  :precondition
    (and
      (at ?r ?w)
      (plot-at ?p ?w)
      (needs-water ?p)
      (>= (water-level ?r) 1)
      (>= (battery-level ?r) (water-energy-cost))
    )
  :effect
    (and
      (not (moisture-low ?p))
      (moisture-ok ?p)
      (not (needs-water ?p))
      (watered ?p)
      (decrease (water-level ?r) 1)
      (decrease (battery-level ?r) (water-energy-cost))
    )
  ) 

; diagnose fertilizer need based on inspection results, no energy cost
  (:action diagnose-pesticide-need
  :parameters (?p - plot)
  :precondition
    (and
      (inspected ?p)
      (pest-present ?p)
      (not (needs-pesticide ?p))
    )
  :effect
    (needs-pesticide ?p)
)

; apply pesticide to plot, improving pest condition and consuming pesticide and battery energy
  (:action spray-pesticide
  :parameters (?r - robot ?p - plot ?w - waypoint)
  :precondition
    (and
      (at ?r ?w)
      (plot-at ?p ?w)
      (needs-pesticide ?p)
      (>= (pesticide-level ?r) 1)
      (>= (battery-level ?r) (spray-energy-cost))
    )
  :effect
    (and
      (not (pest-present ?p))
      (pest-absent ?p)
      (not (needs-pesticide ?p))
      (sprayed ?p)
      (decrease (pesticide-level ?r) 1)
      (decrease (battery-level ?r) (spray-energy-cost))
    )
)

; diagnose fertilizer need based on inspection results, no energy cost
  (:action diagnose-fertilizer-need
    :parameters (?p - plot)
    :precondition
      (and
        (inspected ?p)
        (nutrient-low ?p)
        (not (needs-fertilizer ?p))
      )
    :effect
      (needs-fertilizer ?p)
)

; apply fertilizer to plot, improving nutrient condition and consuming fertilizer and battery energy
  (:action fertilize-plot
    :parameters (?r - robot ?p - plot ?w - waypoint)
    :precondition
      (and
        (at ?r ?w)
        (plot-at ?p ?w)
        (needs-fertilizer ?p)
        (>= (fertilizer-level ?r) 1)
        (>= (battery-level ?r) (fertilize-energy-cost))
      )
    :effect
      (and
        (not (nutrient-low ?p))
        (nutrient-ok ?p)
        (not (needs-fertilizer ?p))
        (fertilized ?p)
        (decrease (fertilizer-level ?r) 1)
        (decrease (battery-level ?r) (fertilize-energy-cost))
      )
)

)