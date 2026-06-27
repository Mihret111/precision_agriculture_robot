(define (problem precision-agriculture-robot-q1-multiplot-adjacency-only)
  (:domain precision-agriculture-robot-q1)

  (:objects
    robot1 - robot
    plot1 plot2 plot3 plot4 - plot
    wp-depot wp-row1 wp-row2 wp-row3 wp-row4 - waypoint
  )

  (:init
    ;; ------------------------------------------------------------------
    ;; Robot start and operating mode
    ;; ------------------------------------------------------------------
    ;; The robot starts at the depot. The depot is the service location
    ;; where charging and all liquid/solid treatment resources are available.
    (at robot1 wp-depot)
    (mobile robot1)
    (free robot1)

    ;; ------------------------------------------------------------------
    ;; Field map / high-level route abstraction
    ;; ------------------------------------------------------------------
    ;; Neutral location names are used so the waypoint names do not reveal
    ;; whether a plot is dry, pest-infested, nutrient deficient, or healthy.
    ;;
    ;; Conceptual map:
    ;;
    ;;   wp-depot --2-- wp-row1 --2-- wp-row2 --2-- wp-row3 --2-- wp-row4
    ;;
    ;; Additional direct route abstractions are included with costs equal to
    ;; the shortest headland/field-lane distance between the locations. These
    ;; are not crop-condition facts; they are only travel-cost information.

    (adjacent wp-depot wp-row1)
    (adjacent wp-row1 wp-depot)

    (adjacent wp-row1 wp-row2)
    (adjacent wp-row2 wp-row1)
    (adjacent wp-row2 wp-row3)
    (adjacent wp-row3 wp-row2)
    (adjacent wp-row3 wp-row4)
    (adjacent wp-row4 wp-row3)


    ;; Plot locations. The plot number is only an identifier; the condition
    ;; predicates below define what is actually wrong or healthy on each plot.
    (plot-at plot1 wp-row1)
    (plot-at plot2 wp-row2)
    (plot-at plot3 wp-row3)
    (plot-at plot4 wp-row4)

    ;; Depot service resources
    (recharge-station-at wp-depot)
    (refill-water-at wp-depot)
    (refill-fertilizer-at wp-depot)
    (refill-pesticide-at wp-depot)
    (refill-growth-support-at wp-depot)

    ;; ------------------------------------------------------------------
    ;; Underlying plot conditions
    ;; ------------------------------------------------------------------
    ;; These are the true field conditions in the planning instance. The robot
    ;; still has to inspect, observe, and diagnose before intervention actions
    ;; become authorized.

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

    ;; plot4: healthy plot; classify and report, no treatment
    (moisture-ok plot4)
    (pest-absent plot4)
    (nutrient-ok plot4)
    (growth-normal plot4)
    (health-good plot4)
    (soil-quality-good plot4)

    ;; ------------------------------------------------------------------
    ;; Initial battery/resources: mission preparation is meaningful
    ;; ------------------------------------------------------------------
    (= (battery-level robot1) 10)
    (= (water-level robot1) 0)
    (= (fertilizer-level robot1) 0)
    (= (pesticide-level robot1) 0)
    (= (growth-support-level robot1) 0)

    ;; capacities and reserve
    (= (battery-capacity robot1) 100)
    (= (battery-reserve robot1) 10)
    (= (assessment-energy-budget) 6)
    (= (water-capacity robot1) 1)
    (= (fertilizer-capacity robot1) 1)
    (= (pesticide-capacity robot1) 1)
    (= (growth-support-capacity robot1) 1)

    ;; ------------------------------------------------------------------
    ;; High-level route energy costs
    ;; ------------------------------------------------------------------
    ;; Costs encode relative distance from the depot and between rows.
    ;; One physically adjacent step costs 2 energy units.
    (= (move-energy-cost wp-depot wp-row1) 2)
    (= (move-energy-cost wp-row1 wp-depot) 2)

    (= (move-energy-cost wp-row1 wp-row2) 2)
    (= (move-energy-cost wp-row2 wp-row1) 2)
    (= (move-energy-cost wp-row2 wp-row3) 2)
    (= (move-energy-cost wp-row3 wp-row2) 2)
    (= (move-energy-cost wp-row3 wp-row4) 2)
    (= (move-energy-cost wp-row4 wp-row3) 2)

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
    (= (report-energy-cost) 1)

    ;; treatment dose sizes
    (= (water-dose) 1)
    (= (fertilizer-dose) 1)
    (= (pesticide-dose) 1)
    (= (growth-support-dose) 1)

    ;; abstract planning cost values
    (= (diagnosis-cost) 1)
    (= (service-action-cost) 1)
    (= (total-cost) 0)
  )

  (:goal
    (and
      (reported plot1)
      (reported plot2)
      (reported plot3)
      (reported plot4)
    )
  )

  (:metric minimize (total-cost))
)