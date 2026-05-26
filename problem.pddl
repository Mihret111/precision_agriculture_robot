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
  )

  ; (:goal
  ;   (and
  ;     (moisture-ok plot1)
  ;     (treated plot1)
  ;   )
  ; )
  (:goal
    (and
      (pest-absent plot1)
      (treated plot1)
    )
  )
)