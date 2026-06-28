(define (domain precision-agriculture-robot-q1)

  (:requirements :adl :typing :numeric-fluents)

  (:types
    robot
    plot
    waypoint
  )

  (:predicates
    ;; location and high-level mission routes
    (at ?r - robot ?w - waypoint)
    (adjacent ?from - waypoint ?to - waypoint)
    (plot-at ?p - plot ?w - waypoint)

    ;; robot modes
    (mobile ?r - robot)
    (free ?r - robot)
    (handling ?r - robot ?p - plot)
    (service-trip ?r - robot ?p - plot)

    ;; local assessment session
    (assessing ?r - robot ?p - plot)
    (assessment-complete ?p - plot)

    ;; service stations
    (recharge-station-at ?w - waypoint)
    (refill-water-at ?w - waypoint)
    (refill-fertilizer-at ?w - waypoint)
    (refill-pesticide-at ?w - waypoint)
    (refill-growth-support-at ?w - waypoint)

    ;; sensing and diagnosis
    (inspected ?p - plot)
    (moisture-observed ?p - plot)
    (pest-observed ?p - plot)
    (nutrient-observed ?p - plot)
    (growth-observed ?p - plot)

    (moisture-classified ?p - plot)
    (pest-classified ?p - plot)
    (nutrient-classified ?p - plot)
    (growth-classified ?p - plot)

    (needs-water ?p - plot)
    (needs-fertilizer ?p - plot)
    (needs-pesticide ?p - plot)
    (needs-growth-support ?p - plot)

    (water-not-needed ?p - plot)
    (fertilizer-not-needed ?p - plot)
    (pesticide-not-needed ?p - plot)
    (growth-support-not-needed ?p - plot)

    ;; plot conditions
    (moisture-low ?p - plot)
    (moisture-ok ?p - plot)
    (nutrient-low ?p - plot)
    (nutrient-ok ?p - plot)
    (pest-present ?p - plot)
    (pest-absent ?p - plot)
    (growth-delayed ?p - plot)
    (growth-normal ?p - plot)
    (health-good ?p - plot)
    (health-stressed ?p - plot)
    (soil-quality-good ?p - plot)
    (soil-quality-degraded ?p - plot)

    ;; action history / completion
    (watered ?p - plot)
    (fertilized ?p - plot)
    (sprayed ?p - plot)
    (growth-supported ?p - plot)
    (reported ?p - plot)
  )

  (:functions
    ;; robot battery and consumables
    (battery-level ?r - robot)
    (water-level ?r - robot)
    (fertilizer-level ?r - robot)
    (pesticide-level ?r - robot)
    (growth-support-level ?r - robot)

    ;; capacities and reserve
    (battery-capacity ?r - robot)
    (water-capacity ?r - robot)
    (fertilizer-capacity ?r - robot)
    (pesticide-capacity ?r - robot)
    (growth-support-capacity ?r - robot)
    (battery-reserve ?r - robot)

    ;; expected local energy before opening a plot case
    (assessment-energy-budget)

    ;; movement / operation energy costs
    (move-energy-cost ?from - waypoint ?to - waypoint)
    (inspect-energy-cost)
    (sense-moisture-energy-cost)
    (sense-pest-energy-cost)
    (sense-nutrient-energy-cost)
    (sense-growth-energy-cost)
    (water-energy-cost)
    (fertilize-energy-cost)
    (spray-energy-cost)
    (growth-support-energy-cost)
    (report-energy-cost)

    ;; treatment dose sizes
    (water-dose)
    (fertilizer-dose)
    (pesticide-dose)
    (growth-support-dose)

    ;; abstract planning cost values
    (diagnosis-cost)
    (service-action-cost)
    (total-cost)
  )

  ;; ------------------------------------------------------------
  ;; Task-directed navigation
  ;; There is intentionally no generic free-roaming move action.
  ;; A free robot travels because it is opening a concrete plot case.

  (:action travel-to-plot-and-inspect
    :parameters (?r - robot ?p - plot ?from - waypoint ?to - waypoint)
    :precondition
      (and
        (free ?r)
        (mobile ?r)
        (at ?r ?from)
        (plot-at ?p ?to)
        (adjacent ?from ?to)
        (not (inspected ?p))
        (not (reported ?p))
        (>= (battery-level ?r)
            (+ (move-energy-cost ?from ?to)
               (+ (assessment-energy-budget) (battery-reserve ?r))))
      )
    :effect
      (and
        (not (at ?r ?from))
        (at ?r ?to)
        (not (free ?r))
        (not (mobile ?r))
        (handling ?r ?p)
        (assessing ?r ?p)
        (inspected ?p)
        (decrease (battery-level ?r) (move-energy-cost ?from ?to))
        (decrease (battery-level ?r) (inspect-energy-cost))
        (increase (total-cost) (move-energy-cost ?from ?to))
        (increase (total-cost) (inspect-energy-cost))
      )
  )

  (:action move-service-trip
    :parameters (?r - robot ?p - plot ?from - waypoint ?to - waypoint)
    :precondition
      (and
        (service-trip ?r ?p)
        (mobile ?r)
        (at ?r ?from)
        (adjacent ?from ?to)
        (not (= ?from ?to))
        (>= (battery-level ?r) (move-energy-cost ?from ?to))
      )
    :effect
      (and
        (not (at ?r ?from))
        (at ?r ?to)
        (decrease (battery-level ?r) (move-energy-cost ?from ?to))
        (increase (total-cost) (move-energy-cost ?from ?to))
      )
  )

  ;; ------------------------------------------------------------
  ;; Local assessment
  ;; ------------------------------------------------------------

  (:action observe-moisture
    :parameters (?r - robot ?p - plot ?w - waypoint)
    :precondition
      (and
        (assessing ?r ?p)
        (at ?r ?w)
        (plot-at ?p ?w)
        (inspected ?p)
        (not (reported ?p))
        (not (moisture-observed ?p))
        (>= (battery-level ?r) (sense-moisture-energy-cost))
      )
    :effect
      (and
        (moisture-observed ?p)
        (decrease (battery-level ?r) (sense-moisture-energy-cost))
        (increase (total-cost) (sense-moisture-energy-cost))
      )
  )

  (:action observe-pests
    :parameters (?r - robot ?p - plot ?w - waypoint)
    :precondition
      (and
        (assessing ?r ?p)
        (at ?r ?w)
        (plot-at ?p ?w)
        (inspected ?p)
        (not (reported ?p))
        (not (pest-observed ?p))
        (>= (battery-level ?r) (sense-pest-energy-cost))
      )
    :effect
      (and
        (pest-observed ?p)
        (decrease (battery-level ?r) (sense-pest-energy-cost))
        (increase (total-cost) (sense-pest-energy-cost))
      )
  )

  (:action observe-nutrients
    :parameters (?r - robot ?p - plot ?w - waypoint)
    :precondition
      (and
        (assessing ?r ?p)
        (at ?r ?w)
        (plot-at ?p ?w)
        (inspected ?p)
        (not (reported ?p))
        (not (nutrient-observed ?p))
        (>= (battery-level ?r) (sense-nutrient-energy-cost))
      )
    :effect
      (and
        (nutrient-observed ?p)
        (decrease (battery-level ?r) (sense-nutrient-energy-cost))
        (increase (total-cost) (sense-nutrient-energy-cost))
      )
  )

  (:action observe-growth
    :parameters (?r - robot ?p - plot ?w - waypoint)
    :precondition
      (and
        (assessing ?r ?p)
        (at ?r ?w)
        (plot-at ?p ?w)
        (inspected ?p)
        (not (reported ?p))
        (not (growth-observed ?p))
        (>= (battery-level ?r) (sense-growth-energy-cost))
      )
    :effect
      (and
        (growth-observed ?p)
        (decrease (battery-level ?r) (sense-growth-energy-cost))
        (increase (total-cost) (sense-growth-energy-cost))
      )
  )

  (:action diagnose-water-need
    :parameters (?r - robot ?p - plot)
    :precondition (and (assessing ?r ?p) (not (reported ?p)) (moisture-observed ?p) (moisture-low ?p) (not (moisture-classified ?p)))
    :effect (and (needs-water ?p) (moisture-classified ?p) (increase (total-cost) (diagnosis-cost)))
  )

  (:action diagnose-water-not-needed
    :parameters (?r - robot ?p - plot)
    :precondition (and (assessing ?r ?p) (not (reported ?p)) (moisture-observed ?p) (moisture-ok ?p) (not (moisture-classified ?p)))
    :effect (and (water-not-needed ?p) (moisture-classified ?p) (increase (total-cost) (diagnosis-cost)))
  )

  (:action diagnose-pesticide-need
    :parameters (?r - robot ?p - plot)
    :precondition (and (assessing ?r ?p) (not (reported ?p)) (pest-observed ?p) (pest-present ?p) (not (pest-classified ?p)))
    :effect (and (needs-pesticide ?p) (pest-classified ?p) (increase (total-cost) (diagnosis-cost)))
  )

  (:action diagnose-pesticide-not-needed
    :parameters (?r - robot ?p - plot)
    :precondition (and (assessing ?r ?p) (not (reported ?p)) (pest-observed ?p) (pest-absent ?p) (not (pest-classified ?p)))
    :effect (and (pesticide-not-needed ?p) (pest-classified ?p) (increase (total-cost) (diagnosis-cost)))
  )

  (:action diagnose-fertilizer-need
    :parameters (?r - robot ?p - plot)
    :precondition (and (assessing ?r ?p) (not (reported ?p)) (nutrient-observed ?p) (nutrient-low ?p) (not (nutrient-classified ?p)))
    :effect (and (needs-fertilizer ?p) (nutrient-classified ?p) (increase (total-cost) (diagnosis-cost)))
  )

  (:action diagnose-fertilizer-not-needed
    :parameters (?r - robot ?p - plot)
    :precondition (and (assessing ?r ?p) (not (reported ?p)) (nutrient-observed ?p) (nutrient-ok ?p) (not (nutrient-classified ?p)))
    :effect (and (fertilizer-not-needed ?p) (nutrient-classified ?p) (increase (total-cost) (diagnosis-cost)))
  )

  (:action diagnose-growth-support-need
    :parameters (?r - robot ?p - plot)
    :precondition (and (assessing ?r ?p) (not (reported ?p)) (growth-observed ?p) (growth-delayed ?p) (not (growth-classified ?p)))
    :effect (and (needs-growth-support ?p) (growth-classified ?p) (increase (total-cost) (diagnosis-cost)))
  )

  (:action diagnose-growth-support-not-needed
    :parameters (?r - robot ?p - plot)
    :precondition (and (assessing ?r ?p) (not (reported ?p)) (growth-observed ?p) (growth-normal ?p) (not (growth-classified ?p)))
    :effect (and (growth-support-not-needed ?p) (growth-classified ?p) (increase (total-cost) (diagnosis-cost)))
  )

  (:action finish-assessment
    :parameters (?r - robot ?p - plot)
    :precondition
      (and
        (handling ?r ?p)
        (assessing ?r ?p)
        (not (reported ?p))
        (moisture-classified ?p)
        (pest-classified ?p)
        (nutrient-classified ?p)
        (growth-classified ?p)
      )
    :effect
      (and
        (not (assessing ?r ?p))
        (assessment-complete ?p)
        (mobile ?r)
        (increase (total-cost) (diagnosis-cost))
      )
  )

  ;; ------------------------------------------------------------
  ;; Diagnosis-authorized targeted interventions
  (:action water-plot
    :parameters (?r - robot ?p - plot ?w - waypoint)
    :precondition
      (and
        (handling ?r ?p)
        (mobile ?r)
        (at ?r ?w)
        (plot-at ?p ?w)
        (assessment-complete ?p)
        (needs-water ?p)
        (moisture-low ?p)
        (not (watered ?p))
        (not (reported ?p))
        (>= (water-level ?r) (water-dose))
        (>= (battery-level ?r) (+ (water-energy-cost) (battery-reserve ?r)))
      )
    :effect
      (and
        (decrease (water-level ?r) (water-dose))
        (decrease (battery-level ?r) (water-energy-cost))
        (increase (total-cost) (water-energy-cost))
        (increase (total-cost) (water-dose))
        (not (moisture-low ?p))
        (moisture-ok ?p)
        (not (needs-water ?p))
        (watered ?p)
      )
  )

  (:action spray-pesticide
    :parameters (?r - robot ?p - plot ?w - waypoint)
    :precondition
      (and
        (handling ?r ?p)
        (mobile ?r)
        (at ?r ?w)
        (plot-at ?p ?w)
        (assessment-complete ?p)
        (needs-pesticide ?p)
        (pest-present ?p)
        (not (sprayed ?p))
        (not (reported ?p))
        (>= (pesticide-level ?r) (pesticide-dose))
        (>= (battery-level ?r) (+ (spray-energy-cost) (battery-reserve ?r)))
      )
    :effect
      (and
        (decrease (pesticide-level ?r) (pesticide-dose))
        (decrease (battery-level ?r) (spray-energy-cost))
        (increase (total-cost) (spray-energy-cost))
        (increase (total-cost) (pesticide-dose))
        (not (pest-present ?p))
        (pest-absent ?p)
        (not (needs-pesticide ?p))
        (sprayed ?p)
      )
  )

  (:action fertilize-plot
    :parameters (?r - robot ?p - plot ?w - waypoint)
    :precondition
      (and
        (handling ?r ?p)
        (mobile ?r)
        (at ?r ?w)
        (plot-at ?p ?w)
        (assessment-complete ?p)
        (needs-fertilizer ?p)
        (nutrient-low ?p)
        (moisture-ok ?p)
        (pest-absent ?p)
        (not (fertilized ?p))
        (not (reported ?p))
        (>= (fertilizer-level ?r) (fertilizer-dose))
        (>= (battery-level ?r) (+ (fertilize-energy-cost) (battery-reserve ?r)))
      )
    :effect
      (and
        (decrease (fertilizer-level ?r) (fertilizer-dose))
        (decrease (battery-level ?r) (fertilize-energy-cost))
        (increase (total-cost) (fertilize-energy-cost))
        (increase (total-cost) (fertilizer-dose))
        (not (nutrient-low ?p))
        (nutrient-ok ?p)
        (not (needs-fertilizer ?p))
        (fertilized ?p)
      )
  )

  (:action support-growth
    :parameters (?r - robot ?p - plot ?w - waypoint)
    :precondition
      (and
        (handling ?r ?p)
        (mobile ?r)
        (at ?r ?w)
        (plot-at ?p ?w)
        (assessment-complete ?p)
        (needs-growth-support ?p)
        (growth-delayed ?p)
        (moisture-ok ?p)
        (pest-absent ?p)
        (nutrient-ok ?p)
        (health-good ?p)
        (not (growth-supported ?p))
        (not (reported ?p))
        (>= (growth-support-level ?r) (growth-support-dose))
        (>= (battery-level ?r) (+ (growth-support-energy-cost) (battery-reserve ?r)))
      )
    :effect
      (and
        (decrease (growth-support-level ?r) (growth-support-dose))
        (decrease (battery-level ?r) (growth-support-energy-cost))
        (increase (total-cost) (growth-support-energy-cost))
        (increase (total-cost) (growth-support-dose))
        (not (growth-delayed ?p))
        (growth-normal ?p)
        (not (needs-growth-support ?p))
        (growth-supported ?p)
      )
  )

  ;; Explicit harmful side-effect actions, used to show that inappropriate
  ;; intervention is representable but should not be selected in valid safe plans

  (:action unsafe-water-not-needed
    :parameters (?r - robot ?p - plot ?w - waypoint)
    :precondition
      (and
        (handling ?r ?p)
        (mobile ?r)
        (at ?r ?w)
        (plot-at ?p ?w)
        (assessment-complete ?p)
        (water-not-needed ?p)
        (not (reported ?p))
        (>= (water-level ?r) (water-dose))
        (>= (battery-level ?r) (+ (water-energy-cost) (battery-reserve ?r)))
      )
    :effect
      (and
        (decrease (water-level ?r) (water-dose))
        (decrease (battery-level ?r) (water-energy-cost))
        (not (soil-quality-good ?p))
        (soil-quality-degraded ?p)
        (increase (total-cost) (water-energy-cost))
        (increase (total-cost) (water-dose))
      )
  )

  (:action unsafe-fertilize-bad-context
    :parameters (?r - robot ?p - plot ?w - waypoint)
    :precondition
      (and
        (handling ?r ?p)
        (mobile ?r)
        (at ?r ?w)
        (plot-at ?p ?w)
        (assessment-complete ?p)
        (not (reported ?p))
        (or (fertilizer-not-needed ?p) (moisture-low ?p) (pest-present ?p))
        (>= (fertilizer-level ?r) (fertilizer-dose))
        (>= (battery-level ?r) (+ (fertilize-energy-cost) (battery-reserve ?r)))
      )
    :effect
      (and
        (decrease (fertilizer-level ?r) (fertilizer-dose))
        (decrease (battery-level ?r) (fertilize-energy-cost))
        (not (health-good ?p))
        (health-stressed ?p)
        (increase (total-cost) (fertilize-energy-cost))
        (increase (total-cost) (fertilizer-dose))
      )
  )

  ;; ------------------------------------------------------------
  ;; Reporting closes the plot case

  (:action report-plot-status
    :parameters (?r - robot ?p - plot ?w - waypoint)
    :precondition
      (and
        (handling ?r ?p)
        (mobile ?r)
        (at ?r ?w)
        (plot-at ?p ?w)
        (assessment-complete ?p)
        (not (reported ?p))
        (moisture-classified ?p)
        (pest-classified ?p)
        (nutrient-classified ?p)
        (growth-classified ?p)
        (moisture-ok ?p)
        (pest-absent ?p)
        (nutrient-ok ?p)
        (growth-normal ?p)
        (health-good ?p)
        (soil-quality-good ?p)
        (>= (battery-level ?r) (+ (report-energy-cost) (battery-reserve ?r)))
      )
    :effect
      (and
        (reported ?p)
        (not (handling ?r ?p))
        (free ?r)
        (decrease (battery-level ?r) (report-energy-cost))
        (increase (total-cost) (report-energy-cost))
      )
  )

  ;; ------------------------------------------------------------
  ;; Depot service and same-case service recovery

  (:action recharge-battery
    :parameters (?r - robot ?w - waypoint)
    :precondition
      (and
        (free ?r)
        (mobile ?r)
        (at ?r ?w)
        (recharge-station-at ?w)
        (< (battery-level ?r) (battery-capacity ?r))
      )
    :effect
      (and
        (assign (battery-level ?r) (battery-capacity ?r))
        (increase (total-cost) (service-action-cost))
      )
  )

  (:action refill-water
    :parameters (?r - robot ?w - waypoint)
    :precondition
      (and
        (free ?r)
        (mobile ?r)
        (at ?r ?w)
        (refill-water-at ?w)
        (< (water-level ?r) (water-dose))
      )
    :effect
      (and
        (assign (water-level ?r) (water-capacity ?r))
        (increase (total-cost) (service-action-cost))
      )
  )

  (:action refill-fertilizer
    :parameters (?r - robot ?w - waypoint)
    :precondition
      (and
        (free ?r)
        (mobile ?r)
        (at ?r ?w)
        (refill-fertilizer-at ?w)
        (< (fertilizer-level ?r) (fertilizer-dose))
      )
    :effect
      (and
        (assign (fertilizer-level ?r) (fertilizer-capacity ?r))
        (increase (total-cost) (service-action-cost))
      )
  )

  (:action refill-pesticide
    :parameters (?r - robot ?w - waypoint)
    :precondition
      (and
        (free ?r)
        (mobile ?r)
        (at ?r ?w)
        (refill-pesticide-at ?w)
        (< (pesticide-level ?r) (pesticide-dose))
      )
    :effect
      (and
        (assign (pesticide-level ?r) (pesticide-capacity ?r))
        (increase (total-cost) (service-action-cost))
      )
  )

  (:action refill-growth-support
    :parameters (?r - robot ?w - waypoint)
    :precondition
      (and
        (free ?r)
        (mobile ?r)
        (at ?r ?w)
        (refill-growth-support-at ?w)
        (< (growth-support-level ?r) (growth-support-dose))
      )
    :effect
      (and
        (assign (growth-support-level ?r) (growth-support-capacity ?r))
        (increase (total-cost) (service-action-cost))
      )
  )

  (:action suspend-case-for-service
    :parameters (?r - robot ?p - plot ?w - waypoint)
    :precondition
      (and
        (handling ?r ?p)
        (mobile ?r)
        (at ?r ?w)
        (plot-at ?p ?w)
        (not (reported ?p))
        (or
          (< (battery-level ?r) (battery-reserve ?r))
          (and (needs-water ?p) (< (water-level ?r) (water-dose)))
          (and (needs-fertilizer ?p) (< (fertilizer-level ?r) (fertilizer-dose)))
          (and (needs-pesticide ?p) (< (pesticide-level ?r) (pesticide-dose)))
          (and (needs-growth-support ?p) (< (growth-support-level ?r) (growth-support-dose)))
        )
      )
    :effect
      (and
        (not (handling ?r ?p))
        (service-trip ?r ?p)
        (increase (total-cost) (service-action-cost))
      )
  )

  (:action recharge-battery-for-case
    :parameters (?r - robot ?p - plot ?w - waypoint)
    :precondition
      (and
        (service-trip ?r ?p)
        (mobile ?r)
        (at ?r ?w)
        (recharge-station-at ?w)
        (< (battery-level ?r) (battery-capacity ?r))
      )
    :effect
      (and
        (assign (battery-level ?r) (battery-capacity ?r))
        (increase (total-cost) (service-action-cost))
      )
  )

  (:action refill-water-for-case
    :parameters (?r - robot ?p - plot ?w - waypoint)
    :precondition
      (and
        (service-trip ?r ?p)
        (mobile ?r)
        (at ?r ?w)
        (refill-water-at ?w)
        (needs-water ?p)
        (< (water-level ?r) (water-dose))
      )
    :effect
      (and
        (assign (water-level ?r) (water-capacity ?r))
        (increase (total-cost) (service-action-cost))
      )
  )

  (:action refill-fertilizer-for-case
    :parameters (?r - robot ?p - plot ?w - waypoint)
    :precondition
      (and
        (service-trip ?r ?p)
        (mobile ?r)
        (at ?r ?w)
        (refill-fertilizer-at ?w)
        (needs-fertilizer ?p)
        (< (fertilizer-level ?r) (fertilizer-dose))
      )
    :effect
      (and
        (assign (fertilizer-level ?r) (fertilizer-capacity ?r))
        (increase (total-cost) (service-action-cost))
      )
  )

  (:action refill-pesticide-for-case
    :parameters (?r - robot ?p - plot ?w - waypoint)
    :precondition
      (and
        (service-trip ?r ?p)
        (mobile ?r)
        (at ?r ?w)
        (refill-pesticide-at ?w)
        (needs-pesticide ?p)
        (< (pesticide-level ?r) (pesticide-dose))
      )
    :effect
      (and
        (assign (pesticide-level ?r) (pesticide-capacity ?r))
        (increase (total-cost) (service-action-cost))
      )
  )

  (:action refill-growth-support-for-case
    :parameters (?r - robot ?p - plot ?w - waypoint)
    :precondition
      (and
        (service-trip ?r ?p)
        (mobile ?r)
        (at ?r ?w)
        (refill-growth-support-at ?w)
        (needs-growth-support ?p)
        (< (growth-support-level ?r) (growth-support-dose))
      )
    :effect
      (and
        (assign (growth-support-level ?r) (growth-support-capacity ?r))
        (increase (total-cost) (service-action-cost))
      )
  )

  (:action resume-case-after-service
    :parameters (?r - robot ?p - plot ?w - waypoint)
    :precondition
      (and
        (service-trip ?r ?p)
        (mobile ?r)
        (at ?r ?w)
        (plot-at ?p ?w)
        (not (reported ?p))
      )
    :effect
      (and
        (not (service-trip ?r ?p))
        (handling ?r ?p)
        (increase (total-cost) (service-action-cost))
      )
  )
)