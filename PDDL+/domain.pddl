(define (domain precision-agriculture-robot)
  (:requirements :typing :numeric-fluents :negative-preconditions :disjunctive-preconditions)

  (:types robot plot waypoint)

  (:predicates
    ;; topology and robot execution state
    (at ?r - robot ?w - waypoint)
    (adjacent ?from - waypoint ?to - waypoint)
    (plot-at ?p - plot ?w - waypoint)
    (active ?p - plot)
    (robot-free ?r - robot)
    (mission-active ?r - robot)
    (travelling ?r - robot ?p - plot ?from - waypoint ?to - waypoint)

    ;; durative sensing state, implemented with processes and events (for ENHSP compatibility)
    (sensing-moisture ?r - robot ?p - plot)
    (sensing-pests ?r - robot ?p - plot)
    (sensing-nutrients ?r - robot ?p - plot)
    (sensing-growth ?r - robot ?p - plot)
    (sensing-failure ?r - robot ?p - plot)
    (verifying-moisture ?r - robot ?p - plot)
    (irrigating ?r - robot ?p - plot)
    (spraying-pesticide ?r - robot ?p - plot)
    (fertilizing ?r - robot ?p - plot)
    (supporting-growth ?r - robot ?p - plot)
    (verifying-pests ?r - robot ?p - plot)
    (verifying-nutrients ?r - robot ?p - plot)
    (verifying-growth ?r - robot ?p - plot)

    ;; local sensing annd assessment states
    (inspected ?p - plot)
    (moisture-observed ?p - plot)
    (pest-observed ?p - plot)
    (nutrient-observed ?p - plot)
    (growth-observed ?p - plot)

    (moisture-classified ?p - plot)
    (pest-classified ?p - plot)
    (nutrient-classified ?p - plot)
    (growth-classified ?p - plot)
    (assessment-complete ?p - plot)

    ;; separated successful and failure reporting are separated
    (reported ?p - plot)
    (failure-reported ?p - plot)
    (failure-observed ?p - plot)
    (moisture-restored ?p - plot)
    (moisture-verified ?p - plot)
    (pest-cleared ?p - plot)
    (pest-verified ?p - plot)
    (nutrient-restored ?p - plot)
    (nutrient-verified ?p - plot)
    (growth-restored ?p - plot)
    (growth-verified ?p - plot)

    ;; threshold states produced by events
    (moisture-deficient ?p - plot)
    (nutrient-deficient ?p - plot)
    (pest-infested ?p - plot)
    (growth-delayed ?p - plot)

    ;; explicit diagnosis states
    (needs-water ?p - plot)
    (needs-fertilizer ?p - plot)
    (needs-pesticide ?p - plot)
    (needs-growth-support ?p - plot)

    (water-not-needed ?p - plot)
    (fertilizer-not-needed ?p - plot)
    (pesticide-not-needed ?p - plot)
    (growth-support-not-needed ?p - plot)

    ;; failure/damage
    (treatment-damaged ?p - plot)
    (crop-failed ?p - plot)

    ;; operational failure states added in 
    (robot-disabled ?r - robot)
    (resource-depleted ?r - robot)
    (treatment-incomplete ?p - plot)
    (resource-limited-reported ?p - plot)

    ;; refill recovery state: high-level depot refill primitive
    ;; The crop and treatment dynamics remain continuous; refill logistics are a discrete mission service layer
    (water-refill-station ?w - waypoint)
    (water-refill-service ?r - robot ?p - plot)
    (water-refilled-for-case ?r - robot ?p - plot)
  )

  (:functions
    ;; robot, travel and timed sensing
    (battery-level ?r - robot)
    (battery-reserve ?r - robot)
    (travel-progress ?r - robot)
    (travel-rate ?r - robot)
    (travel-battery-rate ?r - robot)
    (travel-distance ?from - waypoint ?to - waypoint)

    (observation-progress ?r - robot)
    (observation-rate ?r - robot)
    (observation-battery-rate ?r - robot)

    (water-level ?r - robot)
    (irrigation-rate ?r - robot ?p - plot)
    (irrigation-water-rate ?r - robot ?p - plot)
    (irrigation-battery-rate ?r - robot)

    (pesticide-level ?r - robot)
    (pesticide-spray-rate ?r - robot ?p - plot)
    (pesticide-resource-rate ?r - robot ?p - plot)
    (pesticide-battery-rate ?r - robot)

    (fertilizer-level ?r - robot)
    (fertilization-rate ?r - robot ?p - plot)
    (fertilizer-resource-rate ?r - robot ?p - plot)
    (fertilization-battery-rate ?r - robot)

    (growth-support-level ?r - robot)
    (growth-support-rate ?r - robot ?p - plot)
    (growth-support-resource-rate ?r - robot ?p - plot)
    (growth-support-battery-rate ?r - robot)

    ;; minimum resource predicted to complete a treatment safely
    (required-water ?p - plot)
    (required-pesticide ?p - plot)
    (required-fertilizer ?p - plot)
    (required-growth-support ?p - plot)

    ;; refill/depot-service quantities and costs
    (water-capacity ?r - robot)
    (refill-energy-cost)
    (service-travel-cost)

    (safe-moisture-target ?p - plot)
    (safe-pest-target ?p - plot)
    (safe-nutrient-target ?p - plot)
    (safe-growth-target ?p - plot)
    (moisture-observation-time ?p - plot)
    (pest-observation-time ?p - plot)
    (nutrient-observation-time ?p - plot)
    (growth-observation-time ?p - plot)
    (failure-observation-time ?p - plot)
    (moisture-verification-time ?p - plot)
    (pest-verification-time ?p - plot)
    (nutrient-verification-time ?p - plot)
    (growth-verification-time ?p - plot)

    ;; action costs
    (start-sense-cost)
    (diagnosis-cost)
    (water-energy-cost)
    (fertilize-energy-cost)
    (spray-energy-cost)
    (growth-support-energy-cost)
    (report-energy-cost)

    ;; continuous crop/soil state variables
    (moisture-level ?p - plot)
    (nutrient-level ?p - plot)
    (pest-level ?p - plot)
    (growth-index ?p - plot)
    (damage-level ?p - plot)
    (toxicity-level ?p - plot)

    ;; threshold values
    (moisture-threshold ?p - plot)
    (nutrient-threshold ?p - plot)
    (pest-threshold ?p - plot)
    (growth-threshold ?p - plot)
    (failure-threshold ?p - plot)
    (toxicity-threshold ?p - plot)

    ;; continuous evolution rates
    (moisture-loss-rate ?p - plot)
    (nutrient-loss-rate ?p - plot)
    (pest-growth-rate ?p - plot)
    (growth-decline-rate ?p - plot)
    (moisture-stress-rate ?p - plot)
    (nutrient-stress-rate ?p - plot)
    (pest-stress-rate ?p - plot)
    (growth-stress-rate ?p - plot)

    ;; cross-coupled biological impact rates: deficiencies can also slow growth
    (moisture-impact-on-growth-rate ?p - plot)
    (nutrient-impact-on-growth-rate ?p - plot)
    (pest-impact-on-growth-rate ?p - plot)

    ;; treatment magnitudes and side effects
    (water-boost ?p - plot)
    (fertilizer-boost ?p - plot)
    (pesticide-reduction ?p - plot)
    (growth-boost ?p - plot)
    (wrong-treatment-toxicity ?p - plot)

    ;; objective
    (time-cost-rate ?r - robot)
    (irrigation-time-cost ?r - robot ?p - plot)
    (pesticide-time-cost ?r - robot ?p - plot)
    (fertilization-time-cost ?r - robot ?p - plot)
    (growth-support-time-cost ?r - robot ?p - plot)
    (total-cost)
  )

  ;; ------------------------------------------------------------------
  ;; PDDL+ PROCESSES: continuous change while time passes:
  

  (:process travel-progress-process
    :parameters (?r - robot ?p - plot ?from - waypoint ?to - waypoint)
    :precondition (and (travelling ?r ?p ?from ?to) (not (robot-disabled ?r)))
    :effect (and
      (increase (travel-progress ?r) (* #t (travel-rate ?r)))
      (decrease (battery-level ?r) (* #t (travel-battery-rate ?r)))
    )
  )

  (:process moisture-sensing-process
    :parameters (?r - robot ?p - plot)
    :precondition (and (sensing-moisture ?r ?p) (not (robot-disabled ?r)))
    :effect (and
      (increase (observation-progress ?r) (* #t (observation-rate ?r)))
      (decrease (battery-level ?r) (* #t (observation-battery-rate ?r)))
    )
  )

  (:process pest-sensing-process
    :parameters (?r - robot ?p - plot)
    :precondition (and (sensing-pests ?r ?p) (not (robot-disabled ?r)))
    :effect (and
      (increase (observation-progress ?r) (* #t (observation-rate ?r)))
      (decrease (battery-level ?r) (* #t (observation-battery-rate ?r)))
    )
  )

  (:process nutrient-sensing-process
    :parameters (?r - robot ?p - plot)
    :precondition (and (sensing-nutrients ?r ?p) (not (robot-disabled ?r)))
    :effect (and
      (increase (observation-progress ?r) (* #t (observation-rate ?r)))
      (decrease (battery-level ?r) (* #t (observation-battery-rate ?r)))
    )
  )

  (:process growth-sensing-process
    :parameters (?r - robot ?p - plot)
    :precondition (and (sensing-growth ?r ?p) (not (robot-disabled ?r)))
    :effect (and
      (increase (observation-progress ?r) (* #t (observation-rate ?r)))
      (decrease (battery-level ?r) (* #t (observation-battery-rate ?r)))
    )
  )

  (:process failure-sensing-process
    :parameters (?r - robot ?p - plot)
    :precondition (and (sensing-failure ?r ?p) (not (robot-disabled ?r)))
    :effect (and
      (increase (observation-progress ?r) (* #t (observation-rate ?r)))
      (decrease (battery-level ?r) (* #t (observation-battery-rate ?r)))
    )
  )

  (:process moisture-verification-process
    :parameters (?r - robot ?p - plot)
    :precondition (and (verifying-moisture ?r ?p) (not (robot-disabled ?r)))
    :effect (and
      (increase (observation-progress ?r) (* #t (observation-rate ?r)))
      (decrease (battery-level ?r) (* #t (observation-battery-rate ?r)))
    )
  )

  (:process pest-verification-process
    :parameters (?r - robot ?p - plot)
    :precondition (and (verifying-pests ?r ?p) (not (robot-disabled ?r)))
    :effect (and
      (increase (observation-progress ?r) (* #t (observation-rate ?r)))
      (decrease (battery-level ?r) (* #t (observation-battery-rate ?r)))
    )
  )

  (:process nutrient-verification-process
    :parameters (?r - robot ?p - plot)
    :precondition (and (verifying-nutrients ?r ?p) (not (robot-disabled ?r)))
    :effect (and
      (increase (observation-progress ?r) (* #t (observation-rate ?r)))
      (decrease (battery-level ?r) (* #t (observation-battery-rate ?r)))
    )
  )

  (:process growth-verification-process
    :parameters (?r - robot ?p - plot)
    :precondition (and (verifying-growth ?r ?p) (not (robot-disabled ?r)))
    :effect (and
      (increase (observation-progress ?r) (* #t (observation-rate ?r)))
      (decrease (battery-level ?r) (* #t (observation-battery-rate ?r)))
    )
  )

  (:process irrigation-process
    :parameters (?r - robot ?p - plot)
    :precondition (and (irrigating ?r ?p) (not (robot-disabled ?r)))
    :effect (and
      (increase (moisture-level ?p) (* #t (irrigation-rate ?r ?p)))
      (decrease (water-level ?r) (* #t (irrigation-water-rate ?r ?p)))
      (decrease (battery-level ?r) (* #t (irrigation-battery-rate ?r)))
    )
  )

  (:process pesticide-spraying-process
    :parameters (?r - robot ?p - plot)
    :precondition (and (spraying-pesticide ?r ?p) (not (robot-disabled ?r)))
    :effect (and
      (decrease (pest-level ?p) (* #t (pesticide-spray-rate ?r ?p)))
      (decrease (pesticide-level ?r) (* #t (pesticide-resource-rate ?r ?p)))
      (decrease (battery-level ?r) (* #t (pesticide-battery-rate ?r)))
    )
  )

  (:process fertilization-process
    :parameters (?r - robot ?p - plot)
    :precondition (and (fertilizing ?r ?p) (not (robot-disabled ?r)))
    :effect (and
      (increase (nutrient-level ?p) (* #t (fertilization-rate ?r ?p)))
      (decrease (fertilizer-level ?r) (* #t (fertilizer-resource-rate ?r ?p)))
      (decrease (battery-level ?r) (* #t (fertilization-battery-rate ?r)))
    )
  )

  (:process growth-support-process
    :parameters (?r - robot ?p - plot)
    :precondition (and (supporting-growth ?r ?p) (not (robot-disabled ?r)))
    :effect (and
      (increase (growth-index ?p) (* #t (growth-support-rate ?r ?p)))
      (decrease (growth-support-level ?r) (* #t (growth-support-resource-rate ?r ?p)))
      (decrease (battery-level ?r) (* #t (growth-support-battery-rate ?r)))
    )
  )

  (:process moisture-decrease
    :parameters (?p - plot)
    :precondition (and (active ?p) (not (crop-failed ?p)))
    :effect (decrease (moisture-level ?p) (* #t (moisture-loss-rate ?p)))
  )

  (:process nutrient-depletion
    :parameters (?p - plot)
    :precondition (and (active ?p) (not (crop-failed ?p)))
    :effect (decrease (nutrient-level ?p) (* #t (nutrient-loss-rate ?p)))
  )

  (:process pest-spread
    :parameters (?p - plot)
    :precondition (and (active ?p) (not (crop-failed ?p)))
    :effect (increase (pest-level ?p) (* #t (pest-growth-rate ?p)))
  )

  (:process growth-decline
    :parameters (?p - plot)
    :precondition (and (active ?p) (not (crop-failed ?p)))
    :effect (decrease (growth-index ?p) (* #t (growth-decline-rate ?p)))
  )

  ;; Cross-coupled crop dynamics: water/nutrient/pest stress can also degrade growth.
  ;; :- mechanism that makes delayed primary treatment create secondary growth delay.
  (:process moisture-stress-growth-decline
    :parameters (?p - plot)
    :precondition (and (active ?p) (moisture-deficient ?p) (not (crop-failed ?p)))
    :effect (decrease (growth-index ?p) (* #t (moisture-impact-on-growth-rate ?p)))
  )

  (:process nutrient-stress-growth-decline
    :parameters (?p - plot)
    :precondition (and (active ?p) (nutrient-deficient ?p) (not (crop-failed ?p)))
    :effect (decrease (growth-index ?p) (* #t (nutrient-impact-on-growth-rate ?p)))
  )

  (:process pest-stress-growth-decline
    :parameters (?p - plot)
    :precondition (and (active ?p) (pest-infested ?p) (not (crop-failed ?p)))
    :effect (decrease (growth-index ?p) (* #t (pest-impact-on-growth-rate ?p)))
  )

  (:process moisture-stress-damage
    :parameters (?p - plot)
    :precondition (and (active ?p) (moisture-deficient ?p) (not (crop-failed ?p)))
    :effect (increase (damage-level ?p) (* #t (moisture-stress-rate ?p)))
  )

  (:process nutrient-stress-damage
    :parameters (?p - plot)
    :precondition (and (active ?p) (nutrient-deficient ?p) (not (crop-failed ?p)))
    :effect (increase (damage-level ?p) (* #t (nutrient-stress-rate ?p)))
  )

  (:process pest-stress-damage
    :parameters (?p - plot)
    :precondition (and (active ?p) (pest-infested ?p) (not (crop-failed ?p)))
    :effect (increase (damage-level ?p) (* #t (pest-stress-rate ?p)))
  )

  (:process growth-stress-damage
    :parameters (?p - plot)
    :precondition (and (active ?p) (growth-delayed ?p) (not (crop-failed ?p)))
    :effect (increase (damage-level ?p) (* #t (growth-stress-rate ?p)))
  )

  ;; ------------------------------------------------------------------
  ;; PDDL+ EVENTS: threshold crossings and completion events

  (:event arrival-at-plot
    :parameters (?r - robot ?p - plot ?from - waypoint ?to - waypoint)
    :precondition (and
      (travelling ?r ?p ?from ?to)
      (>= (travel-progress ?r) (travel-distance ?from ?to))
    )
    :effect (and
      (not (travelling ?r ?p ?from ?to))
      (at ?r ?to)
      (inspected ?p)
      (robot-free ?r)
      (not (robot-disabled ?r))
      (assign (travel-progress ?r) 0)
    )
  )

  (:event moisture-observation-complete
    :parameters (?r - robot ?p - plot)
    :precondition (and
      (sensing-moisture ?r ?p)
      (>= (observation-progress ?r) (moisture-observation-time ?p))
    )
    :effect (and
      (not (sensing-moisture ?r ?p))
      (moisture-observed ?p)
      (robot-free ?r)
      (not (robot-disabled ?r))
      (assign (observation-progress ?r) 0)
    )
  )

  (:event pest-observation-complete
    :parameters (?r - robot ?p - plot)
    :precondition (and
      (sensing-pests ?r ?p)
      (>= (observation-progress ?r) (pest-observation-time ?p))
    )
    :effect (and
      (not (sensing-pests ?r ?p))
      (pest-observed ?p)
      (robot-free ?r)
      (not (robot-disabled ?r))
      (assign (observation-progress ?r) 0)
    )
  )

  (:event nutrient-observation-complete
    :parameters (?r - robot ?p - plot)
    :precondition (and
      (sensing-nutrients ?r ?p)
      (>= (observation-progress ?r) (nutrient-observation-time ?p))
    )
    :effect (and
      (not (sensing-nutrients ?r ?p))
      (nutrient-observed ?p)
      (robot-free ?r)
      (not (robot-disabled ?r))
      (assign (observation-progress ?r) 0)
    )
  )

  (:event growth-observation-complete
    :parameters (?r - robot ?p - plot)
    :precondition (and
      (sensing-growth ?r ?p)
      (>= (observation-progress ?r) (growth-observation-time ?p))
    )
    :effect (and
      (not (sensing-growth ?r ?p))
      (growth-observed ?p)
      (robot-free ?r)
      (not (robot-disabled ?r))
      (assign (observation-progress ?r) 0)
    )
  )

  (:event failure-observation-complete
    :parameters (?r - robot ?p - plot)
    :precondition (and
      (sensing-failure ?r ?p)
      (>= (observation-progress ?r) (failure-observation-time ?p))
    )
    :effect (and
      (not (sensing-failure ?r ?p))
      (failure-observed ?p)
      (robot-free ?r)
      (not (robot-disabled ?r))
      (assign (observation-progress ?r) 0)
    )
  )

  (:event moisture-verification-complete
    :parameters (?r - robot ?p - plot)
    :precondition (and
      (verifying-moisture ?r ?p)
      (>= (observation-progress ?r) (moisture-verification-time ?p))
      (not (moisture-deficient ?p))
    )
    :effect (and
      (not (verifying-moisture ?r ?p))
      (moisture-verified ?p)
      (robot-free ?r)
      (not (robot-disabled ?r))
      (assign (observation-progress ?r) 0)
    )
  )

  (:event pest-verification-complete
    :parameters (?r - robot ?p - plot)
    :precondition (and
      (verifying-pests ?r ?p)
      (>= (observation-progress ?r) (pest-verification-time ?p))
      (not (pest-infested ?p))
    )
    :effect (and
      (not (verifying-pests ?r ?p))
      (pest-verified ?p)
      (robot-free ?r)
      (not (robot-disabled ?r))
      (assign (observation-progress ?r) 0)
    )
  )

  (:event nutrient-verification-complete
    :parameters (?r - robot ?p - plot)
    :precondition (and
      (verifying-nutrients ?r ?p)
      (>= (observation-progress ?r) (nutrient-verification-time ?p))
      (not (nutrient-deficient ?p))
    )
    :effect (and
      (not (verifying-nutrients ?r ?p))
      (nutrient-verified ?p)
      (robot-free ?r)
      (not (robot-disabled ?r))
      (assign (observation-progress ?r) 0)
    )
  )

  (:event growth-verification-complete
    :parameters (?r - robot ?p - plot)
    :precondition (and
      (verifying-growth ?r ?p)
      (>= (observation-progress ?r) (growth-verification-time ?p))
      (not (growth-delayed ?p))
    )
    :effect (and
      (not (verifying-growth ?r ?p))
      (growth-verified ?p)
      (robot-free ?r)
      (not (robot-disabled ?r))
      (assign (observation-progress ?r) 0)
    )
  )

  (:event irrigation-target-reached
    :parameters (?r - robot ?p - plot)
    :precondition (and
      (irrigating ?r ?p)
      (>= (moisture-level ?p) (safe-moisture-target ?p))
    )
    :effect (and
      (not (irrigating ?r ?p))
      (robot-free ?r)
      (not (robot-disabled ?r))
      (not (moisture-deficient ?p))
      (not (needs-water ?p))
      (moisture-restored ?p)
    )
  )

  (:event pesticide-target-reached
    :parameters (?r - robot ?p - plot)
    :precondition (and
      (spraying-pesticide ?r ?p)
      (<= (pest-level ?p) (safe-pest-target ?p))
    )
    :effect (and
      (not (spraying-pesticide ?r ?p))
      (robot-free ?r)
      (not (robot-disabled ?r))
      (not (pest-infested ?p))
      (not (needs-pesticide ?p))
      (pest-cleared ?p)
    )
  )

  (:event fertilization-target-reached
    :parameters (?r - robot ?p - plot)
    :precondition (and
      (fertilizing ?r ?p)
      (>= (nutrient-level ?p) (safe-nutrient-target ?p))
    )
    :effect (and
      (not (fertilizing ?r ?p))
      (robot-free ?r)
      (not (robot-disabled ?r))
      (not (nutrient-deficient ?p))
      (not (needs-fertilizer ?p))
      (nutrient-restored ?p)
    )
  )

  (:event growth-support-target-reached
    :parameters (?r - robot ?p - plot)
    :precondition (and
      (supporting-growth ?r ?p)
      (>= (growth-index ?p) (safe-growth-target ?p))
    )
    :effect (and
      (not (supporting-growth ?r ?p))
      (robot-free ?r)
      (not (robot-disabled ?r))
      (not (growth-delayed ?p))
      (not (needs-growth-support ?p))
      (growth-restored ?p)
    )
  )


  ;; operational safety events: depleted battery/resources can stop the mission or an intervention
  (:event battery-reserve-violated
    :parameters (?r - robot)
    :precondition (and
      (not (robot-disabled ?r))
      (<= (battery-level ?r) (battery-reserve ?r))
    )
    :effect (and
      (robot-disabled ?r)
      (not (robot-free ?r))
    )
  )

  (:event water-depleted-during-irrigation
    :parameters (?r - robot ?p - plot)
    :precondition (and
      (irrigating ?r ?p)
      (<= (water-level ?r) 0)
      (< (moisture-level ?p) (safe-moisture-target ?p))
    )
    :effect (and
      (not (irrigating ?r ?p))
      (robot-free ?r)
      (not (robot-disabled ?r))
      (resource-depleted ?r)
      (treatment-incomplete ?p)
      (not (moisture-restored ?p))
      (not (moisture-verified ?p))
    )
  )

  (:event pesticide-depleted-during-spray
    :parameters (?r - robot ?p - plot)
    :precondition (and
      (spraying-pesticide ?r ?p)
      (<= (pesticide-level ?r) 0)
      (> (pest-level ?p) (safe-pest-target ?p))
    )
    :effect (and
      (not (spraying-pesticide ?r ?p))
      (robot-free ?r)
      (not (robot-disabled ?r))
      (resource-depleted ?r)
      (treatment-incomplete ?p)
      (not (pest-cleared ?p))
      (not (pest-verified ?p))
    )
  )

  (:event fertilizer-depleted-during-fertilization
    :parameters (?r - robot ?p - plot)
    :precondition (and
      (fertilizing ?r ?p)
      (<= (fertilizer-level ?r) 0)
      (< (nutrient-level ?p) (safe-nutrient-target ?p))
    )
    :effect (and
      (not (fertilizing ?r ?p))
      (robot-free ?r)
      (not (robot-disabled ?r))
      (resource-depleted ?r)
      (treatment-incomplete ?p)
      (not (nutrient-restored ?p))
      (not (nutrient-verified ?p))
    )
  )

  (:event growth-support-depleted-during-support
    :parameters (?r - robot ?p - plot)
    :precondition (and
      (supporting-growth ?r ?p)
      (<= (growth-support-level ?r) 0)
      (< (growth-index ?p) (safe-growth-target ?p))
    )
    :effect (and
      (not (supporting-growth ?r ?p))
      (robot-free ?r)
      (not (robot-disabled ?r))
      (resource-depleted ?r)
      (treatment-incomplete ?p)
      (not (growth-restored ?p))
      (not (growth-verified ?p))
    )
  )

  (:event moisture-threshold-crossed
    :parameters (?p - plot)
    :precondition (and
      (active ?p)
      (not (moisture-deficient ?p))
      (<= (moisture-level ?p) (moisture-threshold ?p))
    )
    :effect (and
      (moisture-deficient ?p)
      (not (water-not-needed ?p))
      (not (moisture-observed ?p))
      (not (moisture-classified ?p))
      (not (assessment-complete ?p))
      (not (moisture-restored ?p))
      (not (moisture-verified ?p))
    )
  )

  (:event nutrient-threshold-crossed
    :parameters (?p - plot)
    :precondition (and
      (active ?p)
      (not (nutrient-deficient ?p))
      (<= (nutrient-level ?p) (nutrient-threshold ?p))
    )
    :effect (and
      (nutrient-deficient ?p)
      (not (fertilizer-not-needed ?p))
      (not (nutrient-observed ?p))
      (not (nutrient-classified ?p))
      (not (assessment-complete ?p))
      (not (nutrient-restored ?p))
      (not (nutrient-verified ?p))
    )
  )

  (:event pest-threshold-crossed
    :parameters (?p - plot)
    :precondition (and
      (active ?p)
      (not (pest-infested ?p))
      (>= (pest-level ?p) (pest-threshold ?p))
    )
    :effect (and
      (pest-infested ?p)
      (not (pesticide-not-needed ?p))
      (not (pest-observed ?p))
      (not (pest-classified ?p))
      (not (assessment-complete ?p))
      (not (pest-cleared ?p))
      (not (pest-verified ?p))
    )
  )

  (:event growth-threshold-crossed
    :parameters (?p - plot)
    :precondition (and
      (active ?p)
      (not (growth-delayed ?p))
      (<= (growth-index ?p) (growth-threshold ?p))
    )
    :effect (and
      (growth-delayed ?p)
      (not (growth-support-not-needed ?p))
      (not (growth-observed ?p))
      (not (growth-classified ?p))
      (not (assessment-complete ?p))
      (not (growth-restored ?p))
      (not (growth-verified ?p))
    )
  )

  (:event treatment-damage-threshold-crossed
    :parameters (?p - plot)
    :precondition (and
      (not (treatment-damaged ?p))
      (>= (toxicity-level ?p) (toxicity-threshold ?p))
    )
    :effect (treatment-damaged ?p)
  )

  (:event crop-failure-threshold-crossed
    :parameters (?p - plot)
    :precondition (and
      (active ?p)
      (not (crop-failed ?p))
      (>= (damage-level ?p) (failure-threshold ?p))
    )
    :effect (and
      (crop-failed ?p)
      (not (assessment-complete ?p))
      (not (reported ?p))
      (not (moisture-verified ?p))
      (not (moisture-restored ?p))
      (not (pest-verified ?p))
      (not (pest-cleared ?p))
      (not (nutrient-verified ?p))
      (not (nutrient-restored ?p))
      (not (growth-verified ?p))
      (not (growth-restored ?p))
    )
  )

  ;; ------------------------------------------------------------------
  ;; ACTIONS: travel, timed observation starts, embodied diagnosis,
  ;; interventions, and reporting

  (:action start-travel-to-plot
    :parameters (?r - robot ?p - plot ?from - waypoint ?to - waypoint)
    :precondition (and
      (robot-free ?r)
      (not (robot-disabled ?r))
      (at ?r ?from)
      (adjacent ?from ?to)
      (plot-at ?p ?to)
      (not (inspected ?p))
    )
    :effect (and
      (not (robot-free ?r))
      (not (at ?r ?from))
      (travelling ?r ?p ?from ?to)
      (assign (travel-progress ?r) 0)
      (increase (total-cost) (* (time-cost-rate ?r) (travel-distance ?from ?to)))
    )
  )

  (:action start-observe-moisture
    :parameters (?r - robot ?p - plot ?w - waypoint)
    :precondition (and (robot-free ?r) (at ?r ?w) (plot-at ?p ?w) (inspected ?p)
                       (not (reported ?p))
                       (not (moisture-observed ?p)) (not (crop-failed ?p)))
    :effect (and (not (robot-free ?r)) (sensing-moisture ?r ?p)
                 (assign (observation-progress ?r) 0)
                 (increase (total-cost) (start-sense-cost)))
  )

  (:action start-observe-pests
    :parameters (?r - robot ?p - plot ?w - waypoint)
    :precondition (and (robot-free ?r) (at ?r ?w) (plot-at ?p ?w) (inspected ?p)
                       (not (reported ?p))
                       (not (pest-observed ?p)) (not (crop-failed ?p)))
    :effect (and (not (robot-free ?r)) (sensing-pests ?r ?p)
                 (assign (observation-progress ?r) 0)
                 (increase (total-cost) (start-sense-cost)))
  )

  (:action start-observe-nutrients
    :parameters (?r - robot ?p - plot ?w - waypoint)
    :precondition (and (robot-free ?r) (at ?r ?w) (plot-at ?p ?w) (inspected ?p)
                       (not (reported ?p))
                       (not (nutrient-observed ?p)) (not (crop-failed ?p)))
    :effect (and (not (robot-free ?r)) (sensing-nutrients ?r ?p)
                 (assign (observation-progress ?r) 0)
                 (increase (total-cost) (start-sense-cost)))
  )

  (:action start-observe-growth
    :parameters (?r - robot ?p - plot ?w - waypoint)
    :precondition (and (robot-free ?r) (at ?r ?w) (plot-at ?p ?w) (inspected ?p)
                       (not (reported ?p))
                       (not (growth-observed ?p)) (not (crop-failed ?p)))
    :effect (and (not (robot-free ?r)) (sensing-growth ?r ?p)
                 (assign (observation-progress ?r) 0)
                 (increase (total-cost) (start-sense-cost)))
  )

  (:action start-observe-failure-status
    :parameters (?r - robot ?p - plot ?w - waypoint)
    :precondition (and (robot-free ?r) (at ?r ?w) (plot-at ?p ?w)
                       (inspected ?p) (crop-failed ?p)
                       (not (failure-observed ?p)))
    :effect (and (not (robot-free ?r)) (sensing-failure ?r ?p)
                 (assign (observation-progress ?r) 0)
                 (increase (total-cost) (start-sense-cost)))
  )

  (:action start-verify-moisture-after-irrigation
    :parameters (?r - robot ?p - plot ?w - waypoint)
    :precondition (and (robot-free ?r) (at ?r ?w) (plot-at ?p ?w)
                       (assessment-complete ?p)
                       (not (reported ?p))
                       (moisture-restored ?p)
                       (not (moisture-deficient ?p))
                       (not (moisture-verified ?p))
                       (not (crop-failed ?p)))
    :effect (and (not (robot-free ?r)) (verifying-moisture ?r ?p)
                 (assign (observation-progress ?r) 0)
                 (increase (total-cost) (start-sense-cost)))
  )

  (:action start-verify-pests-after-spray
    :parameters (?r - robot ?p - plot ?w - waypoint)
    :precondition (and (robot-free ?r) (at ?r ?w) (plot-at ?p ?w)
                       (assessment-complete ?p)
                       (not (reported ?p))
                       (pest-cleared ?p)
                       (not (pest-infested ?p))
                       (not (pest-verified ?p))
                       (not (crop-failed ?p)))
    :effect (and (not (robot-free ?r)) (verifying-pests ?r ?p)
                 (assign (observation-progress ?r) 0)
                 (increase (total-cost) (start-sense-cost)))
  )

  (:action start-verify-nutrients-after-fertilization
    :parameters (?r - robot ?p - plot ?w - waypoint)
    :precondition (and (robot-free ?r) (at ?r ?w) (plot-at ?p ?w)
                       (assessment-complete ?p)
                       (not (reported ?p))
                       (nutrient-restored ?p)
                       (not (nutrient-deficient ?p))
                       (not (nutrient-verified ?p))
                       (not (crop-failed ?p)))
    :effect (and (not (robot-free ?r)) (verifying-nutrients ?r ?p)
                 (assign (observation-progress ?r) 0)
                 (increase (total-cost) (start-sense-cost)))
  )

  (:action start-verify-growth-after-support
    :parameters (?r - robot ?p - plot ?w - waypoint)
    :precondition (and (robot-free ?r) (at ?r ?w) (plot-at ?p ?w)
                       (assessment-complete ?p)
                       (not (reported ?p))
                       (growth-restored ?p)
                       (not (growth-delayed ?p))
                       (not (growth-verified ?p))
                       (not (crop-failed ?p)))
    :effect (and (not (robot-free ?r)) (verifying-growth ?r ?p)
                 (assign (observation-progress ?r) 0)
                 (increase (total-cost) (start-sense-cost)))
  )

  (:action diagnose-water-need
    :parameters (?r - robot ?p - plot ?w - waypoint)
    :precondition (and (robot-free ?r) (at ?r ?w) (plot-at ?p ?w)
                       (moisture-observed ?p) (moisture-deficient ?p)
                       (not (moisture-classified ?p)) (not (crop-failed ?p)))
    :effect (and (needs-water ?p) (moisture-classified ?p)
                 (increase (total-cost) (diagnosis-cost)))
  )

  (:action diagnose-water-not-needed
    :parameters (?r - robot ?p - plot ?w - waypoint)
    :precondition (and (robot-free ?r) (at ?r ?w) (plot-at ?p ?w)
                       (moisture-observed ?p) (not (moisture-deficient ?p))
                       (not (moisture-classified ?p)) (not (crop-failed ?p)))
    :effect (and (water-not-needed ?p) (moisture-classified ?p)
                 (increase (total-cost) (diagnosis-cost)))
  )

  (:action diagnose-fertilizer-need
    :parameters (?r - robot ?p - plot ?w - waypoint)
    :precondition (and (robot-free ?r) (at ?r ?w) (plot-at ?p ?w)
                       (nutrient-observed ?p) (nutrient-deficient ?p)
                       (not (nutrient-classified ?p)) (not (crop-failed ?p)))
    :effect (and (needs-fertilizer ?p) (nutrient-classified ?p)
                 (increase (total-cost) (diagnosis-cost)))
  )

  (:action diagnose-fertilizer-not-needed
    :parameters (?r - robot ?p - plot ?w - waypoint)
    :precondition (and (robot-free ?r) (at ?r ?w) (plot-at ?p ?w)
                       (nutrient-observed ?p) (not (nutrient-deficient ?p))
                       (not (nutrient-classified ?p)) (not (crop-failed ?p)))
    :effect (and (fertilizer-not-needed ?p) (nutrient-classified ?p)
                 (increase (total-cost) (diagnosis-cost)))
  )

  (:action diagnose-pesticide-need
    :parameters (?r - robot ?p - plot ?w - waypoint)
    :precondition (and (robot-free ?r) (at ?r ?w) (plot-at ?p ?w)
                       (pest-observed ?p) (pest-infested ?p)
                       (not (pest-classified ?p)) (not (crop-failed ?p)))
    :effect (and (needs-pesticide ?p) (pest-classified ?p)
                 (increase (total-cost) (diagnosis-cost)))
  )

  (:action diagnose-pesticide-not-needed
    :parameters (?r - robot ?p - plot ?w - waypoint)
    :precondition (and (robot-free ?r) (at ?r ?w) (plot-at ?p ?w)
                       (pest-observed ?p) (not (pest-infested ?p))
                       (not (pest-classified ?p)) (not (crop-failed ?p)))
    :effect (and (pesticide-not-needed ?p) (pest-classified ?p)
                 (increase (total-cost) (diagnosis-cost)))
  )

  (:action diagnose-growth-support-need
    :parameters (?r - robot ?p - plot ?w - waypoint)
    :precondition (and (robot-free ?r) (at ?r ?w) (plot-at ?p ?w)
                       (growth-observed ?p) (growth-delayed ?p)
                       (not (growth-classified ?p)) (not (crop-failed ?p)))
    :effect (and (needs-growth-support ?p) (growth-classified ?p)
                 (increase (total-cost) (diagnosis-cost)))
  )

  (:action diagnose-growth-support-not-needed
    :parameters (?r - robot ?p - plot ?w - waypoint)
    :precondition (and (robot-free ?r) (at ?r ?w) (plot-at ?p ?w)
                       (growth-observed ?p) (not (growth-delayed ?p))
                       (not (growth-classified ?p)) (not (crop-failed ?p)))
    :effect (and (growth-support-not-needed ?p) (growth-classified ?p)
                 (increase (total-cost) (diagnosis-cost)))
  )

  (:action finish-assessment
    :parameters (?r - robot ?p - plot ?w - waypoint)
    :precondition (and
      (robot-free ?r)
      (not (robot-disabled ?r))
      (at ?r ?w) (plot-at ?p ?w)
      (moisture-classified ?p)
      (pest-classified ?p)
      (nutrient-classified ?p)
      (growth-classified ?p)
      (not (crop-failed ?p))
    )
    :effect (assessment-complete ?p)
  )

  (:action start-irrigation
    :parameters (?r - robot ?p - plot ?w - waypoint)
    :precondition (and
      (robot-free ?r)
      (not (robot-disabled ?r))
      (at ?r ?w) (plot-at ?p ?w)
      (assessment-complete ?p)
      (not (reported ?p))
      (needs-water ?p)
      (not (moisture-restored ?p))
      (>= (water-level ?r) (required-water ?p))
      (not (crop-failed ?p))
    )
    :effect (and
      (not (robot-free ?r))
      (irrigating ?r ?p)
      (increase (total-cost) (water-energy-cost))
    )
  )

  (:action start-fertilization
    :parameters (?r - robot ?p - plot ?w - waypoint)
    :precondition (and
      (robot-free ?r)
      (not (robot-disabled ?r))
      (at ?r ?w) (plot-at ?p ?w)
      (assessment-complete ?p)
      (not (reported ?p))
      (needs-fertilizer ?p)
      (not (nutrient-restored ?p))
      (not (moisture-deficient ?p))
      (not (pest-infested ?p))
      (>= (fertilizer-level ?r) (required-fertilizer ?p))
      (not (crop-failed ?p))
    )
    :effect (and
      (not (robot-free ?r))
      (fertilizing ?r ?p)
      (increase (total-cost) (fertilize-energy-cost))
    )
  )

  (:action start-spray-pesticide
    :parameters (?r - robot ?p - plot ?w - waypoint)
    :precondition (and
      (robot-free ?r)
      (not (robot-disabled ?r))
      (at ?r ?w) (plot-at ?p ?w)
      (assessment-complete ?p)
      (not (reported ?p))
      (needs-pesticide ?p)
      (not (pest-cleared ?p))
      (>= (pesticide-level ?r) (required-pesticide ?p))
      (not (crop-failed ?p))
    )
    :effect (and
      (not (robot-free ?r))
      (spraying-pesticide ?r ?p)
      (increase (total-cost) (spray-energy-cost))
    )
  )

  (:action start-growth-support
    :parameters (?r - robot ?p - plot ?w - waypoint)
    :precondition (and
      (robot-free ?r)
      (not (robot-disabled ?r))
      (at ?r ?w) (plot-at ?p ?w)
      (assessment-complete ?p)
      (not (reported ?p))
      (needs-growth-support ?p)
      (not (growth-restored ?p))
      (or (fertilizer-not-needed ?p) (nutrient-verified ?p))
      (not (moisture-deficient ?p))
      (not (nutrient-deficient ?p))
      (not (pest-infested ?p))
      (>= (growth-support-level ?r) (required-growth-support ?p))
      (not (crop-failed ?p))
    )
    :effect (and
      (not (robot-free ?r))
      (supporting-growth ?r ?p)
      (increase (total-cost) (growth-support-energy-cost))
    )
  )

  (:action unsafe-irrigate-not-needed
    :parameters (?r - robot ?p - plot ?w - waypoint)
    :precondition (and
      (robot-free ?r)
      (not (robot-disabled ?r))
      (at ?r ?w) (plot-at ?p ?w)
      (assessment-complete ?p)
      (not (reported ?p))
      (water-not-needed ?p)
      (not (crop-failed ?p))
    )
    :effect (and
      (increase (toxicity-level ?p) (wrong-treatment-toxicity ?p))
      (increase (total-cost) (water-energy-cost))
    )
  )

  (:action unsafe-fertilize-bad-context
    :parameters (?r - robot ?p - plot ?w - waypoint)
    :precondition (and
      (robot-free ?r)
      (not (robot-disabled ?r))
      (at ?r ?w) (plot-at ?p ?w)
      (assessment-complete ?p)
      (not (reported ?p))
      (or (fertilizer-not-needed ?p) (moisture-deficient ?p) (pest-infested ?p))
      (not (crop-failed ?p))
    )
    :effect (and
      (increase (toxicity-level ?p) (wrong-treatment-toxicity ?p))
      (increase (total-cost) (fertilize-energy-cost))
    )
  )

  (:action report-plot-status
    :parameters (?r - robot ?p - plot ?w - waypoint)
    :precondition (and
      (robot-free ?r)
      (not (robot-disabled ?r))
      (at ?r ?w) (plot-at ?p ?w)
      (assessment-complete ?p)
      (or (water-not-needed ?p) (moisture-verified ?p))
      (or (fertilizer-not-needed ?p) (nutrient-verified ?p))
      (or (pesticide-not-needed ?p) (pest-verified ?p))
      (or (growth-support-not-needed ?p) (growth-verified ?p))
      (not (moisture-deficient ?p))
      (not (nutrient-deficient ?p))
      (not (pest-infested ?p))
      (not (growth-delayed ?p))
      (not (treatment-damaged ?p))
      (not (crop-failed ?p))
    )
    :effect (and
      (reported ?p)
      (increase (total-cost) (report-energy-cost))
    )
  )

  (:action report-failure-status
    :parameters (?r - robot ?p - plot ?w - waypoint)
    :precondition (and
      (robot-free ?r)
      (not (robot-disabled ?r))
      (at ?r ?w) (plot-at ?p ?w)
      (crop-failed ?p)
      (failure-observed ?p)
      (not (failure-reported ?p))
    )
    :effect (and
      (failure-reported ?p)
      (increase (total-cost) (report-energy-cost))
    )
  )



  ;; ------------------------------------------------------------------
  ;; RESOURCE RECOVERY ACTIONS: discrete mission-level refill service

  (:action leave-plot-for-water-refill
    :parameters (?r - robot ?p - plot ?plotw - waypoint ?station - waypoint)
    :precondition (and
      (robot-free ?r)
      (not (robot-disabled ?r))
      (at ?r ?plotw)
      (plot-at ?p ?plotw)
      (water-refill-station ?station)
      (adjacent ?plotw ?station)
      (assessment-complete ?p)
      (needs-water ?p)
      (< (water-level ?r) (required-water ?p))
      (not (reported ?p))
      (not (crop-failed ?p))
      (not (water-refill-service ?r ?p))
    )
    :effect (and
      (not (at ?r ?plotw))
      (at ?r ?station)
      (water-refill-service ?r ?p)
      (increase (total-cost) (service-travel-cost))
    )
  )

  (:action refill-water-for-case
    :parameters (?r - robot ?p - plot ?station - waypoint)
    :precondition (and
      (robot-free ?r)
      (not (robot-disabled ?r))
      (at ?r ?station)
      (water-refill-station ?station)
      (water-refill-service ?r ?p)
      (needs-water ?p)
      (< (water-level ?r) (required-water ?p))
      (not (reported ?p))
      (not (crop-failed ?p))
    )
    :effect (and
      (assign (water-level ?r) (water-capacity ?r))
      (water-refilled-for-case ?r ?p)
      (increase (total-cost) (refill-energy-cost))
    )
  )

  (:action return-from-water-refill
    :parameters (?r - robot ?p - plot ?station - waypoint ?plotw - waypoint)
    :precondition (and
      (robot-free ?r)
      (not (robot-disabled ?r))
      (at ?r ?station)
      (water-refill-station ?station)
      (water-refill-service ?r ?p)
      (water-refilled-for-case ?r ?p)
      (plot-at ?p ?plotw)
      (adjacent ?station ?plotw)
      (not (reported ?p))
      (not (crop-failed ?p))
    )
    :effect (and
      (not (at ?r ?station))
      (at ?r ?plotw)
      (not (water-refill-service ?r ?p))
      (increase (total-cost) (service-travel-cost))
    )
  )

  (:action report-resource-limited-status
    :parameters (?r - robot ?p - plot ?w - waypoint)
    :precondition (and
      (robot-free ?r)
      (not (robot-disabled ?r))
      (at ?r ?w) (plot-at ?p ?w)
      (assessment-complete ?p)
      (not (reported ?p))
      (not (failure-reported ?p))
      (not (crop-failed ?p))
      (or
        (and (needs-water ?p) (< (water-level ?r) (required-water ?p)))
        (and (needs-pesticide ?p) (< (pesticide-level ?r) (required-pesticide ?p)))
        (and (needs-fertilizer ?p) (< (fertilizer-level ?r) (required-fertilizer ?p)))
        (and (needs-growth-support ?p) (< (growth-support-level ?r) (required-growth-support ?p)))
        (treatment-incomplete ?p)
      )
    )
    :effect (and
      (resource-limited-reported ?p)
      (increase (total-cost) (report-energy-cost))
    )
  )

)
