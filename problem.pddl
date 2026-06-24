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

    (at robot1 wp-base)

    (refill-water-at wp-base)
    (refill-fertilizer-at wp-base)
    (refill-pesticide-at wp-base)
    (refill-growth-support-at wp-base)

    (= (water-level robot1) 0)
    (= (fertilizer-level robot1) 0)
    (= (pesticide-level robot1) 0)
    (= (growth-support-level robot1) 0)

    (= (water-capacity robot1) 3)
    (= (fertilizer-capacity robot1) 2)
    (= (pesticide-capacity robot1) 2)
    (= (growth-support-capacity robot1) 2)

    ;; include battery if your domain requires function initialization globally
    (= (battery-level robot1) 18)
    (= (battery-capacity robot1) 18)
  )


  

  (:goal
    (and
      ; (moisture-ok plot1)
      ; (pest-absent plot1)
      ; (nutrient-ok plot1)
      ; (watered plot1)
      ; (sprayed plot1)
      ; (fertilized plot1)
      ;(needs-fertilizer plot1)

      ; (reported plot1)

      ; (>= (battery-level robot1) 18)
      ; (>= (water-level robot1) 3)

      (>= (water-level robot1) 3)
      (>= (fertilizer-level robot1) 2)
      (>= (pesticide-level robot1) 2)
      (>= (growth-support-level robot1) 2)

    )
    )
)