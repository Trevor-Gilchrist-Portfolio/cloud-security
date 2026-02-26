# Cloud Security Engineering Portfolio

AWS and Azure security hardening, CSPM, SIEM integration, IaC security automation, and incident response — mapped to NIST SP 800-53 Rev. 5 and FedRAMP baselines.

---

## Portfolio Structure

| Phase | Focus Area | Status | NIST 800-53 Controls |
|---|---|---|---|
| [Phase 0 — Account Hardening](./phase-0-account-hardening) | AWS baseline security: IAM, MFA, CloudTrail, KMS encryption, log retention | ✅ Complete 23FEB2026-25FEB2026| IA-2, AC-6, AU-2, AU-3, AU-9, AU-11, SC-28, CM-8 |
| Phase 1 — Terraform + CI/CD Security | IaC modules (VPC, S3, IAM), Checkov scanning, GitHub Actions pipeline | 🔄 In Progress | CM-6, SA-10, SA-11, SC-7 |
| Phase 2 — AWS Security Hub + Incident Response | Security Hub (NIST standard), CloudGoat attack scenarios, detection and remediation runbooks | Planned | SI-4, IR-4, IR-5, IR-6, CA-7 |
| Phase 3 — Splunk SIEM Integration | CloudTrail → Splunk pipeline, detection rules, Stratus Red Team validation | Planned | AU-6, SI-4, IR-4, IR-5 |
| Phase 4 — Azure Baseline + Multi-Cloud | Defender for Cloud, Azure Terraform modules, AWS vs Azure security comparison | Planned | IA-2, AU-2, SC-7, CA-7 |

---

## Core Toolchain

| Purpose | Tool |
|---|---|
| Infrastructure as Code | Terraform |
| IaC Security Scanning | Checkov |
| CI/CD | GitHub Actions |
| CSPM (AWS) | AWS Security Hub + AWS Config |
| CSPM (Azure) | Microsoft Defender for Cloud |
| Misconfiguration Lab | CloudGoat (Rhino Security Labs) |
| Adversary Simulation | Stratus Red Team |
| SIEM | Splunk Enterprise |
| Scripted Automation | Boto3 (Python) |

---

## Compliance Frameworks Referenced

- **NIST SP 800-53 Rev. 5** — Security and Privacy Controls for Information Systems and Organizations
- **FedRAMP Security Controls Baseline** — Federal Risk and Authorization Management Program
- **CIS AWS Foundations Benchmark v6.0.0**
- **CIS AWS Database Services Benchmark v2.0.0**
- **CIS AWS Compute Services Benchmark v1.1.0**
- **CIS AWS Storage Services Benchmark v1.0.0**

---

## Documentation Standard

Each phase produces runbooks using the **SORT framework:**

- **S**ituation — Environment and misconfiguration context
- **O**bjective — Detection or remediation goal
- **R**esult — Findings, timeline, and resolution
- **T**akeaway — NIST 800-53 control mapping and lessons learned
