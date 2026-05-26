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
    (treated ?p - plot)
  )

  (:action inspect-plot
    :parameters (?p - plot)
    :precondition
      (not (inspected ?p))
    :effect
      (inspected ?p)
  )

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
        (treated ?p)
      )
  )

)