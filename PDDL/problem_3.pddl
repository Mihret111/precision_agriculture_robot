(define (problem q1-problem-3-service-recovery)
  (:domain precision-agriculture-robot-q1)

  (:objects
    robot1 - robot
    plot1 - plot
    wp-entry wp-row1 wp-depot - waypoint
  )

  (:init
    ;; Robot starts at a field-entry waypoint, not at the depot.
    ;; This represents a mid-mission situation where the robot discovers
    ;; a plot-level problem while not carrying the required treatment resource.
    (at robot1 wp-entry)
    (mobile robot1)
    (free robot1)

    ;; Simple service-recovery map:
    ;; wp-entry --2-- wp-row1 --2-- wp-depot
    ;; plot1 is at row1; recharge/refill are available only at the depot.
    (adjacent wp-entry wp-row1)
    (adjacent wp-row1 wp-depot)
    (adjacent wp-depot wp-row1)

    (plot-at plot1 wp-row1)

    (recharge-station-at wp-depot)
    (refill-water-at wp-depot)
    (refill-fertilizer-at wp-depot)
    (refill-pesticide-at wp-depot)
    (refill-growth-support-at wp-depot)

    ;; plot1: single water-stress issue discovered during local assessment.
    (moisture-low plot1)
    (pest-absent plot1)
    (nutrient-ok plot1)
    (growth-normal plot1)
    (health-good plot1)
    (soil-quality-good plot1)

    ;; Battery is enough to reach and assess the plot, but not enough to
    ;; safely complete treatment/report after returning from a service trip
    ;; unless the robot recharges at the depot.
    (= (battery-level robot1) 15)
    (= (battery-capacity robot1) 30)
    (= (battery-reserve robot1) 5)

    ;; The robot is out of water, forcing suspend -> depot refill -> return.
    (= (water-level robot1) 0)
    (= (fertilizer-level robot1) 0)
    (= (pesticide-level robot1) 0)
    (= (growth-support-level robot1) 0)

    (= (water-capacity robot1) 1)
    (= (fertilizer-capacity robot1) 1)
    (= (pesticide-capacity robot1) 1)
    (= (growth-support-capacity robot1) 1)

    ;; Route costs on the simple recovery map.
    (= (move-energy-cost wp-entry wp-row1) 2)
    (= (move-energy-cost wp-row1 wp-depot) 2)
    (= (move-energy-cost wp-depot wp-row1) 2)

    ;; Local assessment and operation costs.
    (= (assessment-energy-budget) 6)
    (= (inspect-energy-cost) 1)
    (= (sense-moisture-energy-cost) 1)
    (= (sense-pest-energy-cost) 1)
    (= (sense-nutrient-energy-cost) 1)
    (= (sense-growth-energy-cost) 1)

    (= (water-energy-cost) 1)
    (= (fertilize-energy-cost) 1)
    (= (spray-energy-cost) 1)
    (= (growth-support-energy-cost) 1)
    (= (report-energy-cost) 1)

    ;; One treatment dose is one abstract normalized unit.
    (= (water-dose) 1)
    (= (fertilizer-dose) 1)
    (= (pesticide-dose) 1)
    (= (growth-support-dose) 1)

    (= (diagnosis-cost) 1)
    (= (service-action-cost) 1)
    (= (total-cost) 0)
  )

  (:goal
    (and
      (reported plot1)
      (watered plot1)
    )
  )

  (:metric minimize (total-cost))
)