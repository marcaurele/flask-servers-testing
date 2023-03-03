import logging
from locust import HttpUser, events, task, constant_throughput

class DdosUser(HttpUser):
    wait_time = constant_throughput(0.5)

    @task
    def ping(self):
        self.client.get('/')


@events.quitting.add_listener
def _(environment, **kw):
    if environment.stats.total.fail_ratio > 0.5:
        logging.error("Test failed due to failure ratio > 50%")
        environment.process_exit_code = 1
    else:
        environment.process_exit_code = 0