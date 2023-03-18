# Python ASGI/WSGI servers test

This repository run _locust_ tests over 3 different WSGI (bjoern[^1], gunicorn[^2]) and ASGI (uvicorn[^3]) servers using [GitHub-hosted runners](https://docs.github.com/en/actions/using-github-hosted-runners/about-github-hosted-runners#supported-runners-and-hardware-resources), based on 2-core CPU (x86_64) & 7 GB of RAM.

## Results

- [bjoern](https://marcaurele.github.io/flask-servers-testing/bjoern-locust-report.html)
- [gunicorn](https://marcaurele.github.io/flask-servers-testing/gunicorn-locust-report.html)
- [uvicorn](https://marcaurele.github.io/flask-servers-testing/uvicorn-locust-report.html)

[^1]: https://github.com/jonashaag/bjoern
[^2]: https://github.com/benoitc/gunicorn
[^3]: https://github.com/encode/uvicorn