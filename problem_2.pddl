(define (problem precision-agriculture-robot-q1-multiplot-test)
  (:domain precision-agriculture-robot-q1)

  (:objects
    robot1 - robot

    plot1 plot2 plot3 plot4 - plot

    wp-base
    wp-water
    wp-pest
    wp-nutrient
    wp-healthy
    wp-service
    - waypoint
  )

  (:init
    ;; robot initial location
    (at robot1 wp-base)

    ;; field topology
    (adjacent wp-base wp-water)
    (adjacent wp-water wp-base)

    (adjacent wp-water wp-pest)
    (adjacent wp-pest wp-water)

    (adjacent wp-pest wp-service)
    (adjacent wp-service wp-pest)

    (adjacent wp-service wp-nutrient)
    (adjacent wp-nutrient wp-service)

    (adjacent wp-nutrient wp-healthy)
    (adjacent wp-healthy wp-nutrient)

    (adjacent wp-healthy wp-base)
    (adjacent wp-base wp-healthy)

    ;; plot locations
    (plot-at plot1 wp-water)
    (plot-at plot2 wp-pest)
    (plot-at plot3 wp-nutrient)
    (plot-at plot4 wp-healthy)

    ;; service stations
    (recharge-station-at wp-base)
    (refill-water-at wp-base)
    (refill-fertilizer-at wp-base)
    (refill-pesticide-at wp-base)
    (refill-growth-support-at wp-base)

    ;; plot1: water issue only
    (moisture-low plot1)
    (pest-absent plot1)
    (nutrient-ok plot1)
    (growth-normal plot1)
    (health-good plot1)
    (soil-quality-good plot1)

    ;; plot2: pest issue only
    (moisture-ok plot2)
    (pest-present plot2)
    (nutrient-ok plot2)
    (growth-normal plot2)
    (health-good plot2)
    (soil-quality-good plot2)

    ;; plot3: nutrient deficiency + delayed growth
    (moisture-ok plot3)
    (pest-absent plot3)
    (nutrient-low plot3)
    (growth-delayed plot3)
    (health-good plot3)
    (soil-quality-good plot3)

    ;; plot4: healthy plot, should not be treated
    (moisture-ok plot4)
    (pest-absent plot4)
    (nutrient-ok plot4)
    (growth-normal plot4)
    (health-good plot4)
    (soil-quality-good plot4)

    ;; robot initial resources: deliberately low
    (= (battery-level robot1) 10)
    (= (water-level robot1) 0)
    (= (fertilizer-level robot1) 0)
    (= (pesticide-level robot1) 0)
    (= (growth-support-level robot1) 0)

    ;; capacities
    (= (battery-capacity robot1) 40)
    (= (water-capacity robot1) 2)
    (= (fertilizer-capacity robot1) 2)
    (= (pesticide-capacity robot1) 2)
    (= (growth-support-capacity robot1) 2)

    ;; movement energy costs
    (= (move-energy-cost wp-base wp-water) 2)
    (= (move-energy-cost wp-water wp-base) 2)

    (= (move-energy-cost wp-water wp-pest) 2)
    (= (move-energy-cost wp-pest wp-water) 2)

    (= (move-energy-cost wp-pest wp-service) 2)
    (= (move-energy-cost wp-service wp-pest) 2)

    (= (move-energy-cost wp-service wp-nutrient) 2)
    (= (move-energy-cost wp-nutrient wp-service) 2)

    (= (move-energy-cost wp-nutrient wp-healthy) 2)
    (= (move-energy-cost wp-healthy wp-nutrient) 2)

    (= (move-energy-cost wp-healthy wp-base) 2)
    (= (move-energy-cost wp-base wp-healthy) 2)

    ;; sensing and treatment energy costs
    (= (inspect-energy-cost) 1)
    (= (sense-moisture-energy-cost) 1)
    (= (sense-pest-energy-cost) 1)
    (= (sense-nutrient-energy-cost) 1)
    (= (sense-growth-energy-cost) 1)

    (= (water-energy-cost) 1)
    (= (fertilize-energy-cost) 1)
    (= (spray-energy-cost) 1)
    (= (growth-support-energy-cost) 1)

    ;; treatment dose sizes
    (= (water-dose) 1)
    (= (fertilizer-dose) 1)
    (= (pesticide-dose) 1)
    (= (growth-support-dose) 1)
  )

  (:goal
    (and
      (reported plot1)
      (reported plot2)
      (reported plot3)
      (reported plot4)
    )
  )
)