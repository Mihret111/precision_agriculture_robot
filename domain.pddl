(define (domain PrecisionFarming)

  (:requirements :strips :typing :negative-preconditions)

  (:types
    plot
  )

  (:predicates
    (inspected ?p - plot)
    (moisture-low ?p - plot)
    (moisture-ok ?p - plot)
    (needs-water ?p - plot)
    (water-available)    
    (watered ?p - plot)
    (sprayed ?p - plot)

    (pest-present ?p - plot)
    (pest-absent ?p - plot)
    (needs-pesticide ?p - plot)
    (pesticide-available)
  )

  ; Inspection actions
  (:action inspect-plot
    :parameters (?p - plot)
    :precondition
      (not (inspected ?p))
    :effect
      (inspected ?p)
  )
  ; Water-related actions
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

  (:action water-plot
    :parameters (?p - plot)
    :precondition
      (and
        (needs-water ?p)
        (water-available)
      )
    :effect
      (and
        (not (moisture-low ?p))
        (moisture-ok ?p)
        (not (needs-water ?p))
        (not (water-available))
        (watered ?p)
      )
  )

  ;  Pesticide-related actions
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

  (:action spray-pesticide
    :parameters (?p - plot)
    :precondition
      (and
        (needs-pesticide ?p)
        (pesticide-available)
      )
    :effect
      (and
        (not (pest-present ?p))
        (pest-absent ?p)
        (not (needs-pesticide ?p))
        (not (pesticide-available))
        (sprayed ?p)
      )
  )
)