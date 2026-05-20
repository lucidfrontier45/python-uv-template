from pydantic import BaseModel

class LambdaEvent(BaseModel):
    name: str
    age: int
    
def handler(event, context):
    lambda_event = LambdaEvent.model_validate(event)
    
    return f"Hello {lambda_event.name}, you are {lambda_event.age} years old!"

if __name__ == "__main__":
    test_event = {
        "name": "Alice",
        "age": 30
    }
    print(handler(test_event, None))