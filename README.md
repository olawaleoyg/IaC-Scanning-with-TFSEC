# IaC-Scanning-with-TFSEC
# DevOps-af-samanja-pod-a-June2024-SHALI-Terraform

Welcome to this GitHub repository. Follow the instructions below to set up your environment.

### <br>Prerequisites<br/>

Before you begin, ensure you have the following installed:

**i.** [Terraform](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)

**ii.** [Git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git)

### <br>Clone the Repository<br/>

In your terminal, clone the **`DevOps-af-samanja-pod-a-June2024-SHALI-Terraform`** 

**`$ git clone DevOps-af-samanja-pod-a-June2024-SHALI-Terraform`**

Navigate to the cloned repository:

**`$ cd DevOps-af-samanja-pod-a-June2024-SHALI-Terraform`**

## GitHub Actions Workflow for Terraform

### Overview
This repository includes a GitHub Actions workflow to manage Terraform deployments across different environments.

### Triggering the Workflow
The workflow is triggered on the following events:
- Push to `main` or feature branches.
- Pull requests targeting `main` or feature branches.

### Managing the Pipeline

#### Feature Branches
For feature branches:
- Terraform only plans changes to the "prod" and "staging" environments.
- Terraform plans and applies changes to the "sandbox" environment.

#### Main Branch
For the `main` branch:
- Terraform plans changes for production environment.
- Manual approval is required to apply changes to production environments.

### Secure Storage
AWS credentials and other sensitive information are stored securely using GitHub Secrets and properly referenced in the workflow.

### Manual Approval
Changes to production require manual approval.

### Example Commands
- **Initialize Terraform**: `terraform init`
- **Validate Terraform**: `terraform validate`
- **Plan Changes**: `terraform plan -out=plan.tfplan`
- **Apply Changes**: `terraform apply -auto-approve plan.tfplan`

### <br>Additional Notes<br/>

**i.** Ensure that your Terraform configuration files (**`.tf`** files) are correctly configured for your specific infrastructure needs.

**ii.** Review and understand the Terraform documentation related to the providers and resources you are using in your configuration.

### <br>Troubleshooting<br/>

**i.** If you encounter any errors during initialization or planning, check the error messages for guidance.

**ii.** Ensure that your environment variables and configuration files are correctly set up.

## Maintaining the CHANGELOG
The CHANGELOG.md file is an essential document that tracks all notable changes made to the project. It helps team members and users understand what has been added, changed, fixed, or removed in each release.

### How to Update the CHANGELOG

1. Before Merging Pull Requests:

- Ensure that the CHANGELOG.md is updated to reflect any relevant changes introduced by your pull request.
- Add new entries under the [Unreleased] section, including the date when the change was made.

2. Sections to Update:

- Added: For new features or functionalities.
- Changed: For changes in existing features or functionalities.
- Deprecated: For features or functionalities that are no longer recommended for use.
- Removed: For features or functionalities that have been removed from the project.
- Fixed: For any bugs or issues that have been resolved.
- Security: For security-related improvements or fixes.

3. Format:

- Use bullet points for each item.
- Be concise but informative; describe what was done and why if necessary.

4. Example:

- Added: Implemented a new feature to automate AMI builds using Packer.
- Fixed: Resolved an issue where SSH configuration did not correctly disable root login.

5. Versioning:

- Once the changes are released, move the [Unreleased] section to a new versioned section, e.g., [1.0.0] - YYYY-MM-DD, and start a new [Unreleased] section.

##  References
- Consult the [Terraform documentation](https://developer.hashicorp.com/terraform/docs) for additional help and resources.
For [manual approval](https://github.com/trstringer/manual-approval)
- [Workflow syntax for GitHub Actions](https://docs.github.com/en/actions/using-workflows/workflow-syntax-for-github-actions#jobsjob_idenvironment)
- [GitHub Actions documentation](https://docs.github.com/en/actions)

### Instructions to Implement Slack Notifications for GitHub Actions (Failures Notifications Only)


**1. Create a new slack channel:**

- On the slack workspace, Click on the **`+`** button and create a channel.
- Use the naming convention of the existing POD A and just add a suffix of CI/CD.

**2. Obtain a Webhook URL:**

- Visit the [slack api website](https://api.slack.com/)
- Click on **Your Apps** and click on **create an app**.
- In the dialogue box, select the option that creates the app from scratch.
- Name the app and select the relevant workspace
- On the slack api page, click on incoming webhooks and set it up for the newly created channel.
- Copy the webhook URL

**3. Add the Slack Webhook URL to Github Secrets:**

- Go to your repository settings on GitHub.
- Navigate to Settings > Secrets and variables > Actions.
- Click on **Add a new secret**
- Enter the Secret Name: **`SLACK_WEBHOOK_URL`** and paste the Slack Webhook URL.

**4. Update the Terraform Pipeline:**

- Add steps in the pipeline to notify the team via Slack when a failure occurs on the main branch.
- The **`Notify Slack on Failure`** step is added at the end of both the  **`terraform`** and **`deploy-to-prod`** jobs. It checks if the pipeline has failed and triggers a slack notification.
- The Slack Webhook URL is securely stored in GitHub Secrets and is passed into the environment variables.

**5. Usecase for Step:**

```
#  This step checks if the pipeline has failed and triggers a slack notification.  
      - name: Notify Slack on Failure
        if: failure()  # Ensures the step runs only if previous steps failed
        uses: slackapi/slack-github-action@v1.26.0
        with:
          payload: |
            {
              "text": "❌ Terraform Pipeline failed in repository ${{ github.repository }} on branch ${{ github.ref_name }} (commit: ${{ github.sha }}). View details: ${{ github.server_url }}/${{ github.repository }}/actions/runs/${{ github.run_id }}"
            }
        env:
          SLACK_WEBHOOK_URL: ${{ secrets.SLACK_WEBHOOK_URL }}
```

**i.** **Condition to Run Step:**
   -  **`if: failure()`** This condition ensures that this step will only execute if any of the previous steps in the job have failed. If all previous steps succeed, this step will be skipped.

**ii.** **Slack Notification Action:**
   - This line specifies the action to use for sending a Slack notification. The **`slackapi/slack-github-action@v1.26.0`** is a GitHub Action that integrates with Slack's API to send messages to a specified Slack channel.

**iii.** **Slack Message Payload:**

```
with:
  payload: |
    {
      "text": "❌ Terraform Pipeline failed in repository ${{ github.repository }} on branch ${{ github.ref_name }} (commit: ${{ github.sha }}). View details: ${{ github.server_url }}/${{ github.repository }}/actions/runs/${{ github.run_id }}"
    }
```

This section defines the content of the Slack message that will be sent if the pipeline fails:
- ${{ github.repository }}: Replaced by the repository name.
- ${{ github.ref_name }}: Replaced by the name of the branch where the failure occurred.
- ${{ github.sha }}: Replaced by the commit SHA that triggered the pipeline.
- ${{ github.server_url }}/${{ github.repository }}/actions/runs/${{ github.run_id }}: This generates a URL that links directly to the failed GitHub Actions run, allowing easy access to view details.

**iv.** **Environment Variables**

```
env:
  SLACK_WEBHOOK_URL: ${{ secrets.SLACK_WEBHOOK_URL }}
```

- The **`SLACK_WEBHOOK_URL`** environment variable is needed for the Slack action to send the message to the correct Slack channel.
- **`${{ secrets.SLACK_WEBHOOK_URL }}`**: This is a secret stored in the GitHub repository settings. It contains the URL to the Slack webhook, ensuring that the webhook URL is kept secure and is not exposed in the code.

```
### TFSEC USE-CASE

Objective:
Ensure that Terraform configurations are secure and compliant with best practices before being deployed to any environment. By integrating TFSec into the CI/CD pipeline, you can automatically scan your Terraform code for vulnerabilities and misconfigurations, categorize issues by severity, and enforce security policies that prevent high-risk changes from being deployed.

In the pipeline, you will see the TFsec Job:
- Automatically scans Terraform code using TFSec.
- Fails the build if any critical or high-severity issues are detected.
- Allows the pipeline to continue but logs and displays medium and low-severity issues.
- Provides a full report of the TFSec scan for further review.

```
   - name: Scan Terraform with TFSec
      run: |
        # Run full TFSec scan and output to JSON file
        tfsec --format=json --out=tfsec-output.json
        
        # Run scan specifically for high and critical issues
        # Fail the pipeline if any are found
        tfsec --severity=high,critical --out=tfsec-severe.json || exit 1
        
        # Run scan for medium and low issues and log them
        tfsec --severity=medium,low --out=tfsec-warnings.json
```
# How to Use It:
Once the the pipeline is Triggered on every push to main  or feature branch

# TFSec Security Scan:
The pipeline checks out the Terraform code and runs TFSec to scan for security issues.
Step 1: A full TFSec scan is performed, and the results are saved to tfsec-output.json.
Step 2: A focused scan checks for high and critical issues. If any are found, the pipeline fails, preventing the merge.
Step 3: A separate scan logs medium and low-severity issues, allowing the pipeline to continue, but ensuring these warnings are visible.
Reviewing the Output:

The complete TFSec scan results are displayed in the pipeline logs (tfsec-output.json).
Critical and high-severity issues are highlighted separately (tfsec-severe.json), ensuring they receive immediate attention.
Developers and security teams can review the output to understand the issues and take necessary action before proceeding with the deployment.


- Ignoring tfsec checks
Let’s pretend that the problem highlighted by tfsec is not that important to us and that it would be okay to ignore it. We can inform it to tfsec by adding a comment at the top of the resource block where this problem exists.

#tfsec:ignore:<check-id>

# OUTPUT_FOR_THE_TF_SCAN
Passed – This is the number of checks that were passed by tfsec, and no action is required to close these gaps.
Ignored – tfsec ignores some checks due to several reasons. It is possible to skip a certain check explicitly, which we will cover in the next section.
Critical, high, medium, low – each tfsec check is associated with a level of severity or impact. Any failed check is counted against the respective severity. In our example, we have encountered a medium severity check.

# How to fix the error
- you will see the resolution result and click on the link provided to see what should work.
```