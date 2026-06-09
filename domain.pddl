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
    (move-energy-cost ?from - waypoint ?to - waypoint)
    (inspect-energy-cost)
    (water-energy-cost)
    (fertilize-energy-cost)
    (spray-energy-cost)
  )

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

)