# Phase 0 — AWS Account Hardening Baseline

## Overview

This phase establishes the foundational security controls for an AWS environment before any lab work begins. Every control implemented here maps directly to NIST SP 800-53 Rev. 5, the security control framework used by federal agencies and required under FedRAMP authorization.

No cloud security lab is credible without a hardened account baseline. If your audit trail doesn't exist, your incident response exercises are theater.

---

## Controls Implemented

### 1. Cost Governance — AWS Budgets

**What was configured:**
- AWS Budget alert at **$10** (early warning)
- AWS Budget alert at **$25** (hard investigation threshold)
- Email notifications on threshold breach and forecasted overage

**Why this matters:**
In a lab environment with active teardown/rebuild cycles, unexpected cost spikes indicate orphaned resources — running EC2 instances, NAT Gateways, or unattached EBS volumes. Cost governance is an operational discipline, not just a finance concern.

**NIST 800-53 Mapping:**
- **SA-9 (External System Services)** — Monitoring costs of external cloud services ensures accountability and prevents resource waste that could indicate misconfiguration or unauthorized usage.

---

### 2. Identity and Access Management — IAM User with MFA

**What was configured:**
- Dedicated IAM user (`ccadmin`) created for all console and CLI operations
- MFA enabled on the IAM user (virtual MFA device)
- MFA enabled on the root account
- Root account reserved for billing-only and break-glass scenarios

**Why this matters:**
Root account credentials provide unrestricted access to every AWS service and resource. Using root for daily operations violates the principle of least privilege and creates a single point of compromise. MFA adds a second authentication factor, mitigating credential theft from phishing or credential stuffing attacks.

**NIST 800-53 Mapping:**
- **IA-2 (Identification and Authentication)** — Uniquely identify and authenticate organizational users. MFA satisfies IA-2(1) (Multi-Factor Authentication to Privileged Accounts) and IA-2(2) (Multi-Factor Authentication to Non-Privileged Accounts).
- **AC-6 (Least Privilege)** — Allow only authorized accesses necessary to accomplish assigned tasks. Separating root from daily-use IAM enforces this control at the account level.

---

### 3. Audit Logging — AWS CloudTrail

**What was configured:**
- CloudTrail trail: `management-trail-project`
- **Multi-region:** Yes — captures API events from all AWS regions, not just the primary region
- **Event types:** All management events (Read + Write API activity)
- **Exclusions:** None — no KMS or RDS events excluded
- **Dedicated S3 bucket** for log storage (separate from application data)

**Why this matters:**
CloudTrail is the audit backbone of any AWS environment. Every API call — creating resources, modifying IAM policies, deleting security groups — is logged with the caller identity, timestamp, source IP, and request parameters. Without CloudTrail, there is no detection, no incident response, and no forensic evidence. Multi-region logging ensures attackers operating in non-primary regions are still captured.

**NIST 800-53 Mapping:**
- **AU-2 (Audit Events)** — Identify events the system must be capable of logging. CloudTrail management events satisfy this by capturing all control-plane API actions including account creation, privilege changes, and configuration modifications.
- **AU-3 (Content of Audit Records)** — Audit records must contain sufficient information to establish what occurred, when, where, the source, and the outcome. CloudTrail log entries include: event name, timestamp, source IP, user identity (ARN), request parameters, and response elements.
- **AU-12 (Audit Record Generation)** — The system must generate audit records for the events defined in AU-2. CloudTrail generates records automatically for all enabled event types.

---

### 4. Audit Log Integrity — Log File Validation and KMS Encryption

**What was configured:**
- **Log file validation:** Enabled — creates SHA-256 digest files to detect log tampering
- **SSE-KMS encryption:** Enabled — encrypts log files at rest using AWS Key Management Service
- **KMS key alias:** Default (AWS-managed key)

**Why this matters:**
Audit logs are only useful as evidence if their integrity can be verified. Log file validation creates a cryptographic hash chain — if any log file is modified or deleted, the digest comparison will fail. KMS encryption ensures that even if the S3 bucket is exposed, the log contents are not readable without the decryption key.

**NIST 800-53 Mapping:**
- **AU-9 (Protection of Audit Information)** — Protect audit information and tools from unauthorized access, modification, and deletion. Log validation provides integrity verification. KMS encryption provides confidentiality. A dedicated S3 bucket provides access isolation.
- **SC-28 (Protection of Information at Rest)** — Protect the confidentiality and integrity of information at rest. KMS encryption directly satisfies this control for audit log data.

---

### 5. Audit Record Retention — S3 Lifecycle Policy

**What was configured:**
- Lifecycle rule: `90-day-policy-for-logs`
- Scope: Entire log bucket
- Action: Expire (permanently delete) objects after **90 days**
- Transition tiers: None (no Glacier or Infrequent Access — unnecessary at lab scale)

**Why this matters:**
Without a retention policy, log storage grows indefinitely, creating both cost and management overhead. Defining a retention period is a compliance requirement — organizations must document how long audit records are kept and enforce that policy automatically. In production federal systems, retention is typically 1–3 years with transition to cold storage. For a lab environment, 90 days provides sufficient history for incident response exercises while controlling costs.

**NIST 800-53 Mapping:**
- **AU-11 (Audit Record Retention)** — Retain audit records for a defined period to support after-the-fact investigations and meet regulatory requirements. The 90-day lifecycle policy enforces this retention window automatically.
- **AU-4 (Audit Log Storage Capacity)** — Allocate audit log storage capacity and configure auditing to reduce the likelihood of capacity exhaustion. The lifecycle expiry prevents unbounded storage growth.

---

### 6. Resource Tagging — Cloud Asset Inventory

**What was configured:**
- Tag applied to CloudTrail trail and S3 log bucket: `project: security-portfolio`

**Why this matters:**
Tagging is how organizations track what cloud resources exist, who owns them, and what project they belong to. Without tags, cost attribution is impossible and orphaned resources accumulate. In multi-project or multi-team environments, tags are the primary mechanism for access control policies, cost allocation, and automated compliance checks.

**NIST 800-53 Mapping:**
- **CM-8 (Information System Component Inventory)** — Develop and maintain an inventory of system components. Tags serve as the cloud-native implementation of asset inventory, enabling automated discovery and categorization of resources.

---

### 7. Azure Account Provisioning

**What was configured:**
- Azure free account created with $200 credit
- MFA enabled on primary account

**Why this matters:**
The target role requires multi-cloud experience (AWS + Azure). Azure provisioning in Phase 0 ensures the account is ready for Phase 4 (Azure Baseline + Multi-Cloud Narrative) without blocking future progress. MFA is enabled from day one — no account should exist without a second authentication factor.

**NIST 800-53 Mapping:**
- **IA-2 (Identification and Authentication)** — Same control applies across all cloud providers. MFA on Azure satisfies the same requirement as MFA on AWS.

---

## NIST 800-53 Control Summary

| Control ID | Control Name | AWS Implementation |
|---|---|---|
| SA-9 | External System Services | AWS Budgets — cost alerts at $10 and $25 |
| IA-2 | Identification and Authentication | IAM user with MFA; root MFA; Azure MFA |
| AC-6 | Least Privilege | Dedicated IAM user; root reserved for break-glass |
| AU-2 | Audit Events | CloudTrail — all management events, all regions |
| AU-3 | Content of Audit Records | CloudTrail log format — identity, timestamp, IP, parameters |
| AU-4 | Audit Log Storage Capacity | S3 lifecycle policy prevents unbounded growth |
| AU-9 | Protection of Audit Information | Log validation (integrity), KMS encryption (confidentiality), dedicated bucket (isolation) |
| AU-11 | Audit Record Retention | 90-day S3 lifecycle expiry |
| AU-12 | Audit Record Generation | CloudTrail automatic logging for all enabled event types |
| SC-28 | Protection of Information at Rest | SSE-KMS encryption on CloudTrail log bucket |
| CM-8 | System Component Inventory | Resource tagging: `project: security-portfolio` |

---

## What This Phase Does NOT Cover

- IAM policy scoping (addressed in Phase 1 with Terraform)
- Automated alerting on security events (addressed in Phase 3 with Splunk)
- Network security controls (addressed in Phase 1 with VPC Terraform module)
- Azure security configuration beyond MFA (addressed in Phase 4)

---

## Next Phase

**Phase 1 — Terraform Fundamentals + CI/CD Security** → IaC module for VPC, S3, and IAM with Checkov scanning integrated into GitHub Actions.
