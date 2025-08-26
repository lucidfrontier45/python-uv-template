from mangum import Mangum

from app.server import webapp

lambda_handler = Mangum(webapp)
