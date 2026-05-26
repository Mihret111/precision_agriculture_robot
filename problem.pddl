(define (problem farming_problem_step1)
  (:domain PrecisionFarming)

  (:objects
    plot1 - plot
  )

  (:init
    (moisture-low plot1)
    (water-available)
  )

  (:goal
    (and
      (moisture-ok plot1)
      (treated plot1)
    )
  )
)