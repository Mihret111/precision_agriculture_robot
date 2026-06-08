(define (problem farming_problem_step1)
  (:domain PrecisionFarming)

  (:objects
    plot1 - plot
  )

  (:init
    (moisture-low plot1)
    (pest-present plot1)
    (nutrient-low plot1)

    (water-available)
    (pesticide-available)
    (fertilizer-available)

    (health-good plot1)
  )

  (:goal
    (and
      (moisture-ok plot1)
      (pest-absent plot1)
      (nutrient-ok plot1)
      (health-good plot1)        ; added to ensure that the plot's health is good after fertilization (defers weak goal of just having the plot's health be good, since it is already good in the initial state)
      (watered plot1)
      (sprayed plot1)
      (fertilized plot1)
      (reported plot1)           ; added to ensure that the plot's health status is reported after 
    )
  )
)