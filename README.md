# Python ASGI/WSGI servers test

This repository run _locust_ tests over 3 different WSGI (bjoern[^1], gunicorn[^2]) and ASGI (uvicorn[^3]) Python servers using [GitLab-SaaS runners](https://docs.gitlab.com/ee/ci/runners/saas/linux_saas_runner.html), based on 2 vCPUs & 8 GB of RAM.

## Results

- [bjoern](https://python-testing.gitlab.io/flask-servers-testing/bjoern-locust-report.html)
- [gunicorn](https://python-testing.gitlab.io/flask-servers-testing/gunicorn-locust-report.html)
- [uvicorn](https://python-testing.gitlab.io/flask-servers-testing/uvicorn-locust-report.html)

[^1]: https://github.com/jonashaag/bjoern
[^2]: https://github.com/benoitc/gunicorn
[^3]: https://github.com/encode/uvicorn
