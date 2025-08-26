import fastapi

from .backend import hello

webapp = fastapi.FastAPI()


@webapp.get("/")
def index():
    return hello()
