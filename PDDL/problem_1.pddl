(define (problem precision-agriculture-robot-q1-single-delayed-growth-non-depot-scout)
  (:domain precision-agriculture-robot-q1)

  (:objects
    robot1 - robot
    plot1 plot2 plot3 - plot
    wp-depot wp-entry wp-row1 wp-row2 wp-row3 - waypoint
  )

  (:init
    ;; ------------------------------------------------------------------
    ;; Robot start and operating mode
    ;; ------------------------------------------------------------------
    ;; The robot starts already deployed at the field entry, not at the
    ;; depot. The depot remains available as the service station if a
    ;; later service trip is needed.
    (at robot1 wp-entry)
    (mobile robot1)
    (free robot1)

    ;; ------------------------------------------------------------------
    ;; Field map / route abstraction
    ;; ------------------------------------------------------------------
    ;; map:
    ;;
    ;;   wp-depot --2-- wp-entry --2-- wp-row1 --2-- wp-row2 --2-- wp-row3
    ;;
    ;; The robot can only open a plot case at an adjacent row workspace.
    ;; Therefore, starting from wp-entry, it must assess row1 before it can
    ;; progress to row2, and then row3. 
    (adjacent wp-depot wp-entry)
    (adjacent wp-entry wp-depot)

    (adjacent wp-entry wp-row1)
    (adjacent wp-row1 wp-entry)

    (adjacent wp-row1 wp-row2)
    (adjacent wp-row2 wp-row1)

    (adjacent wp-row2 wp-row3)
    (adjacent wp-row3 wp-row2)

    ;; Plot locations
    (plot-at plot1 wp-row1)
    (plot-at plot2 wp-row2)
    (plot-at plot3 wp-row3)

    ;; Depot service resources
    (recharge-station-at wp-depot)
    (refill-water-at wp-depot)
    (refill-fertilizer-at wp-depot)
    (refill-pesticide-at wp-depot)
    (refill-growth-support-at wp-depot)

    ;; ------------------------------------------------------------------
    ;; Underlying plot conditions: one localized issue in the corridor
    ;; plot1 and plot2 are healthy rows discovered during scouting.
    (moisture-ok plot1)
    (pest-absent plot1)
    (nutrient-ok plot1)
    (growth-normal plot1)
    (health-good plot1)
    (soil-quality-good plot1)

    (moisture-ok plot2)
    (pest-absent plot2)
    (nutrient-ok plot2)
    (growth-normal plot2)
    (health-good plot2)
    (soil-quality-good plot2)

    ;; plot3 has the only localized issue: delayed growth.
    ;; Moisture, pest, and nutrient conditions are safe, so the correct
    ;; intervention is growth support only after full local assessment.
    (moisture-ok plot3)
    (pest-absent plot3)
    (nutrient-ok plot3)
    (growth-delayed plot3)
    (health-good plot3)
    (soil-quality-good plot3)

    ;; ------------------------------------------------------------------
    ;; Initial battery/resources
    ;; The robot is already deployed away from the depot, but it starts
    ;; prepared enough to complete this clean scouting/intervention case
    ;; without service recovery. 
    (= (battery-level robot1) 50)
    (= (water-level robot1) 1)
    (= (fertilizer-level robot1) 1)
    (= (pesticide-level robot1) 1)
    (= (growth-support-level robot1) 1)

    ;; capacities and reserve
    (= (battery-capacity robot1) 50)
    (= (battery-reserve robot1) 10)
    (= (assessment-energy-budget) 6)
    (= (water-capacity robot1) 1)
    (= (fertilizer-capacity robot1) 1)
    (= (pesticide-capacity robot1) 1)
    (= (growth-support-capacity robot1) 1)

    ;; ------------------------------------------------------------------
    ;; High-level route energy costs
    ;; ------------------------------------------------------------------
    (= (move-energy-cost wp-depot wp-entry) 2)
    (= (move-energy-cost wp-entry wp-depot) 2)
    (= (move-energy-cost wp-entry wp-row1) 2)
    (= (move-energy-cost wp-row1 wp-entry) 2)
    (= (move-energy-cost wp-row1 wp-row2) 2)
    (= (move-energy-cost wp-row2 wp-row1) 2)
    (= (move-energy-cost wp-row2 wp-row3) 2)
    (= (move-energy-cost wp-row3 wp-row2) 2)

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
      ;; All candidate rows in the scouting corridor are reported.
      ;; Only plot3 should receive a treatment.
      (reported plot1)
      (reported plot2)
      (reported plot3)
    )
  )

  (:metric minimize (total-cost))
)