````markdown
# D5-V10: Precision Agriculture and Targeted Intervention

This project models a precision-agriculture robot using **PDDL** and **PDDL+**.  
The robot inspects field plots, diagnoses local crop conditions, selects targeted interventions, avoids unnecessary treatment, and reasons about limited resources.

## Contents

- `Q1/` — Basic PDDL model  
  Models symbolic inspection, diagnosis, targeted treatment, reporting, heterogeneous plots, and service recovery.

- `Q2/` — PDDL+ model  
  Models continuous condition evolution, threshold events, dynamic treatments, delayed failure, wrong-treatment damage, and resource-limited decisions.

- `report` — Compact one-pager and explanation of assumptions, modelling choices, and implementation.

- `Presentation slides`

## Main Q1 Demonstrations

- Single localized issue
- Multiple heterogeneous plots
- Resource/service recovery using suspend-service-return-resume

## Main Q2 Demonstrations

- Delayed intervention causes crop failure
- Wrong intervention causes treatment damage
- Pest spread requires dynamic pesticide treatment
- Nutrient/growth problem requires staged recovery
- Water scarcity leads to resource-limited reporting

## Running the Models

Use ENHSP to run each domain/problem pair, for example:

```bash
java -jar ~/enhsp/ENHSP-Public/enhsp-dist/enhsp.jar -o domain.pddl -f problem_file.pddl
````


## Observation
The submitted codes and report have been thoroughly reviewed by the teaching assistant, Omar Kashmar.