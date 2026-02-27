import json

def lambda_handler(event, context):
    records = event.get("Records", [])
    for r in records:
        body = r.get("body", "{}")
        msg = json.loads(body)
        print("WORKER received:", json.dumps(msg))
    return {"ok": True, "processed": len(records)}