---
layout: page
title: Pre-Disclosure List Policy
breadcrumbs: true
---

## 1. Purpose

The Pre-Disclosure List ("the List") allows trusted stakeholders to receive
*pre-disclosure* **CVE Records** for the Erlang/OTP, Elixir, Gleam, and related
tooling so they can prepare releases while the information remains strictly
confidential.

## 2. Scope

* **Artifacts covered:** Unpublished CVE Records issued by the Erlang Ecosystem
  Foundation (EEF) CNA. The List provides vulnerability information in the form
  of CVE entries only; patches or code fixes are not distributed.
* **Projects covered:** Exactly the set of software components that fall under
  the EEF CNA’s vulnerability-disclosure scope.
* The List currently operates as **one** global group. In the future, the CNA
  may compartmentalize pre-disclosure lists by project when doing so improves
  confidentiality or operational efficiency.

## 3. Eligibility

An organization or individual may request access if they satisfy the operational
requirements in §8 **and** meet the criteria below.

### 3.1 Baseline requirements (all must be met)

* Be either: a partner of the EEF CNA, **or** an organization that is itself a CNA.
* Have a user or customer base **not limited to your own organization**.
* Maintain a **publicly verifiable track record** of promptly fixing security
  issues up to the present day.
* Be an **active participant and contributor** in the Erlang Ecosystem
  community.

### 3.2 Qualifying roles (meet at least one)

| Category                  | Examples                                                          |
| ------------------------- | ----------------------------------------------------------------- |
| **Distributors**          | Linux/BSD distros, Docker/OCI image publishers, Nixpkgs, Homebrew |
| **Framework maintainers** | Phoenix, Nerves                                                   |
| **End-user projects**     | RabbitMQ, Riak, VerneMQ, MongooseIM                               |
| **Commercial vendors**    | SaaS/PaaS providers, appliance vendors, embedded product makers   |
{: .table.table-striped.table-borderless }

> Membership is **not** a right; acceptance is at the sole discretion of the
> **EEF CNA**.
>
> **Removal:** If a participant later fails to meet any baseline requirement,
> they will be unsubscribed from the List.

## 4. Enrollment Process

1. Send an email to **[cna@erlef.org](mailto:cna@erlef.org)** containing:
   * GitHub **user** ID to be added to the List.
   * A statement that you have read and will follow this policy (§6–§10).
   * (Optional) A public PGP key for encrypted one-off communications.
2. Applications are reviewed on a **continuous basis**; additional information
   may be requested.
3. Approved participants receive an invitation to the private GitHub repository
   `cna-pre-disclosure`.

## 5. List Operations

* All **CVE Records** reside in the private repository. Configure your GitHub
  **Watch** settings to receive notifications.
* Only EEF CNA personnel can modify repository contents. Participants may
  coordinate in **GitHub Discussions** linked to each record.
* Do **not** mirror, fork, or redistribute the repository.

## 6. Confidentiality Requirements

Participants **must**:

1. Keep all information confidential until the CVE Record is **published**.
2. Limit internal sharing strictly to staff who *need-to-know* for patching or
   mitigation.
3. Refrain from hinting publicly (e.g., vague tweets, CVE reservations, release
   notes) that a security fix is forthcoming.
4. **Do not** create public issues, pull requests, or commits that reveal any
   part of the vulnerability—even if the commit message omits details.

## 7. Embargo Timelines

| Scenario                                         | Heads-up window                                                     |
| ------------------------------------------------ | ------------------------------------------------------------------- |
| **Information already public**                   | Immediate publication.                                              |
| **Erlang / Elixir / Gleam core vulnerabilities** | Up to **7 days**.                                                   |
| **Hex.pm package vulnerabilities**               | Publication date set by the maintainer, but must not exceed **7 days** from notification. |
{: .table.table-striped.table-borderless }

We strive to meet these timelines but may adapt them at the
**EEF CNA's discretion**.

## 8. Participant Expectations

| Requirement                                                          | Purpose                                |
| -------------------------------------------------------------------- | -------------------------------------- |
| Ability to apply patches and deploy within the embargo window.       | Protects end users at disclosure time. |
| Maintains an internal security contact alias that responds promptly. | Enables rapid coordination.            |
| Explicit acknowledgement of this policy.                             | Serves as NDA-equivalent confirmation. |
{: .table.table-striped.table-borderless }

## 9. Violations & Penalties

* **First confirmed leak** → Immediate suspension for *minimum* 6 months.
* **Repeated or serious leak** → Permanent removal.
* **Re-admission** is possible only after demonstrating remedial measures
  satisfactory to the EEF CNA.

## 10. Appeals

* Rejections or removals can be appealed by emailing
  **[security@erlef.org](mailto:security@erlef.org)** within 14 days.
* The Security WG will review and reply within 30 days; its decision is final.

## 11. Contact

* **Email:** [cna@erlef.org](mailto:cna@erlef.org)
