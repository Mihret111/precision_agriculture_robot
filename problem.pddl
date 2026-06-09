(define (problem precision-agriculture-robot-q1-test1)
  (:domain precision-agriculture-robot-q1)

  (:objects
    robot1 - robot
    plot1 - plot
    wp-base wp-plot - waypoint
  )

  (:init
    ;; robot initial location
    (at robot1 wp-base)

    ;; field topology
    (adjacent wp-base wp-plot)
    (adjacent wp-plot wp-base)

    ;; plot location
    (plot-at plot1 wp-plot)

    ;; initial plot condition
    (moisture-low plot1)
    (pest-present plot1)
    (nutrient-low plot1)
    (health-good plot1)

    ;; initial numeric resources
    (= (battery-level robot1) 10)
    (= (water-level robot1) 2)
    (= (fertilizer-level robot1) 2)
    (= (pesticide-level robot1) 2)

    ;; action costs
    (= (move-energy-cost wp-base wp-plot) 2)
    (= (move-energy-cost wp-plot wp-base) 2)
    (= (inspect-energy-cost) 1)
    (= (water-energy-cost) 1)
    (= (fertilize-energy-cost) 1)
    (= (spray-energy-cost) 1)
  )

  (:goal
    (and
      ; (moisture-ok plot1)
      ; (pest-absent plot1)
      ; (nutrient-ok plot1)
      ; (watered plot1)
      ; (sprayed plot1)
      ; (fertilized plot1)
      (reported plot1)
    )
  )
)