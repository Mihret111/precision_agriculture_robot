(define (problem farming_problem_step1)
  (:domain PrecisionFarming)

  (:objects
    plot1 - plot
  )

  (:init
    (moisture-low plot1)
    (water-available)

    (pest-present plot1)
    (pesticide-available)

    (health-good plot1)
  )

  (:goal
    (and
      (moisture-ok plot1)
      (pest-absent plot1)
      (health-good plot1)
      (watered plot1)
      (sprayed plot1)
      (reported plot1)
    )
  )
)