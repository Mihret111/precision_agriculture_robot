(define (problem problem_q2_nutrient_growth_staged_recovery_stable)
  (:domain precision-agriculture-robot)

  (:objects
    robot1 - robot
    plot1 - plot
    wp-start wp-row1 - waypoint
  )

  (:init
    (robot-free robot1)
    (mission-active robot1)
    (at robot1 wp-start)
    (adjacent wp-start wp-row1)
    (plot-at plot1 wp-row1)
    (active plot1)

    ;; plot already has a nutrient deficiency and an observable growth delay
    ;; when the robot arrives.... represents a growth symptom caused
    ;; by earlier nutrient stress.
    (nutrient-deficient plot1)
    (growth-delayed plot1)

    (= (battery-level robot1) 100)
    (= (battery-reserve robot1) 1)
    (= (travel-progress robot1) 0)
    (= (travel-rate robot1) 1)
    (= (travel-battery-rate robot1) 0)
    (= (travel-distance wp-start wp-row1) 1)

    (= (observation-progress robot1) 0)
    (= (observation-rate robot1) 1)
    (= (observation-battery-rate robot1) 0)

    (= (water-level robot1) 10)
    (= (irrigation-rate robot1 plot1) 3)
    (= (irrigation-water-rate robot1 plot1) 1)
    (= (irrigation-battery-rate robot1) 0)

    (= (pesticide-level robot1) 10)
    (= (pesticide-spray-rate robot1 plot1) 4)
    (= (pesticide-resource-rate robot1 plot1) 1)
    (= (pesticide-battery-rate robot1) 0)

    (= (fertilizer-level robot1) 10)
    (= (fertilization-rate robot1 plot1) 2)
    (= (fertilizer-resource-rate robot1 plot1) 1)
    (= (fertilization-battery-rate robot1) 0)

    (= (growth-support-level robot1) 10)
    (= (growth-support-rate robot1 plot1) 2)
    (= (growth-support-resource-rate robot1 plot1) 1)
    (= (growth-support-battery-rate robot1) 0)

    (= (required-water plot1) 1)
    (= (required-pesticide plot1) 1)
    (= (required-fertilizer plot1) 1)
    (= (required-growth-support plot1) 1)

    (= (moisture-observation-time plot1) 1)
    (= (pest-observation-time plot1) 1)
    (= (nutrient-observation-time plot1) 1)
    (= (growth-observation-time plot1) 1)
    (= (failure-observation-time plot1) 1)
    (= (moisture-verification-time plot1) 1)
    (= (pest-verification-time plot1) 1)
    (= (nutrient-verification-time plot1) 1)
    (= (growth-verification-time plot1) 1)

    (= (start-sense-cost) 2)
    (= (diagnosis-cost) 1)
    (= (water-energy-cost) 2)
    (= (fertilize-energy-cost) 3)
    (= (spray-energy-cost) 3)
    (= (growth-support-energy-cost) 2)
    (= (report-energy-cost) 1)
    (= (water-capacity robot1) 10)
    (= (refill-energy-cost) 2)
    (= (service-travel-cost) 2)

    ;; Healthy moisture and pest conditions
    (= (moisture-level plot1) 8)
    (= (moisture-threshold plot1) 5)
    (= (safe-moisture-target plot1) 5.6)
    (= (moisture-loss-rate plot1) 0)

    (= (pest-level plot1) 0)
    (= (pest-threshold plot1) 5)
    (= (safe-pest-target plot1) 2)
    (= (pest-growth-rate plot1) 0)

    ;; Nutrient state: already deficient, then restored dynamically by fertilization
    (= (nutrient-level plot1) 2)
    (= (nutrient-threshold plot1) 3)
    (= (safe-nutrient-target plot1) 4)
    (= (nutrient-loss-rate plot1) 0)

    ;; Growth state: already delayed, then restored dynamically after nutrient recovery
    (= (growth-index plot1) 3)
    (= (growth-threshold plot1) 4)
    (= (safe-growth-target plot1) 5)
    (= (growth-decline-rate plot1) 0)

    (= (damage-level plot1) 0)
    (= (failure-threshold plot1) 100)
    (= (toxicity-level plot1) 0)
    (= (toxicity-threshold plot1) 3)

    (= (moisture-stress-rate plot1) 0)
    (= (nutrient-stress-rate plot1) 0)
    (= (pest-stress-rate plot1) 0)
    (= (growth-stress-rate plot1) 0)
    (= (moisture-impact-on-growth-rate plot1) 0)
    (= (nutrient-impact-on-growth-rate plot1) 0)
    (= (pest-impact-on-growth-rate plot1) 0)

    (= (water-boost plot1) 4)
    (= (fertilizer-boost plot1) 3)
    (= (pesticide-reduction plot1) 5)
    (= (growth-boost plot1) 3)
    (= (wrong-treatment-toxicity plot1) 4)

    (= (time-cost-rate robot1) 1)
    (= (irrigation-time-cost robot1 plot1) 1)
    (= (pesticide-time-cost robot1 plot1) 2)
    (= (fertilization-time-cost robot1 plot1) 2)
    (= (growth-support-time-cost robot1 plot1) 1)
    (= (total-cost) 0)
  )

  ;; classify both issues, fertilize first, verify nutrient recovery,
  ;; then perform growth support and verify growth recovery before safe reporting
  (:goal (reported plot1))
  (:metric minimize (total-cost))
)
