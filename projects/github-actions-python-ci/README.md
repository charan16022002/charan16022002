# Python CI with GitHub Actions

A small, testable Python application with a GitHub Actions workflow.

## Pipeline

1. Trigger on relevant pushes, pull requests, or manual dispatch.
2. Check out the repository.
3. Set up Python 3.12.
4. Run unit tests.
5. Run a smoke test.

## Run locally

```bash
cd projects/github-actions-python-ci
python -m unittest discover -s tests -v
python app.py
```

## What this demonstrates

- Workflow triggers and least-privilege `contents: read` permissions
- Automated unit testing
- Pull-request validation
- Repeatable test commands

This is a starter lab committed to the portfolio repository. The workflow still needs a GitHub Actions run to confirm its hosted-runner result.
