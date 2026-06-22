from fastapi import FastAPI, HTTPException

app = FastAPI()

# Static sample data — one entry per sport.
SPORTS = {
    "cricket": {
        "name": "Cricket",
        "players_per_side": 11,
        "origin": "England",
        "description": "A bat-and-ball game played between two teams of eleven players.",
    },
    "football": {
        "name": "Football",
        "players_per_side": 11,
        "origin": "England",
        "description": "A team sport where two teams of eleven try to score by getting the ball into the opposing goal.",
    },
    "tennis": {
        "name": "Tennis",
        "players_per_side": 1,
        "origin": "France",
        "description": "A racket sport played individually (singles) or between two teams of two (doubles).",
    },
    "basketball": {
        "name": "Basketball",
        "players_per_side": 5,
        "origin": "United States",
        "description": "A team sport where two teams of five score by shooting a ball through a hoop.",
    },
    "hockey": {
        "name": "Hockey",
        "players_per_side": 11,
        "origin": "England",
        "description": "A team sport in which players use sticks to hit a ball or puck into the opponent's goal.",
    },
}


@app.get("/")
def hello():
    return {"message": "Hello World from FastAPI"}


@app.get("/sports")
def list_sports():
    """Return the list of available sports you can select."""
    return {"sports": list(SPORTS.keys())}


@app.get("/sport/{name}")
def get_sport(name: str):
    """Return details for the selected sport only."""
    sport = SPORTS.get(name.lower())
    if sport is None:
        raise HTTPException(
            status_code=404,
            detail=f"Sport '{name}' not found. Available: {', '.join(SPORTS.keys())}",
        )
    return sport
