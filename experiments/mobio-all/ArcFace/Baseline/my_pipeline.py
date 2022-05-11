#================== dataset ======================
from bob.bio.face.config.database.mobio_all import database
groups = ['dev','eval']

from IPython.core.debugger import set_trace
# set_trace()

# from bob.bio.face.config.baseline.arcface_insightface import pipeline
from bob.bio.face.config.baseline.arcface_insightface import load

annotation_type = database.annotation_type
fixed_positions = database.fixed_positions
memory_demanding = (database.memory_demanding if hasattr(database, "memory_demanding") else False)

pipeline = load(annotation_type, fixed_positions)