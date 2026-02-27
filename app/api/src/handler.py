import json, os, uuid
import boto3

ddb = boto3.resource("dynamodb")
table = ddb.Table(os.environ["TABLE_NAME"])
sqs = boto3.client("sqs")
QUEUE_URL = os.environ["QUEUE_URL"]

def _resp(status, body):
    return {
        "statusCode": status,
        "headers": {"content-type": "application/json"},
        "body": json.dumps(body),
    }

def _is_http_event(event):
    return isinstance(event, dict) and "requestContext" in event and "http" in event["requestContext"]

def _parse_json(body):
    if not body:
        return {}
    try:
        return json.loads(body)
    except Exception:
        return {}

def handle_http(event):
    method = event.get("requestContext", {}).get("http", {}).get("method")
    path = event.get("rawPath", "")
    path_params = event.get("pathParameters") or {}

    if method == "POST" and path == "/items":
        body = _parse_json(event.get("body"))
        item_id = body.get("id") or str(uuid.uuid4())
        item = {"pk": item_id, "data": body.get("data", {})}
        table.put_item(Item=item)
        return _resp(201, {"id": item_id, "item": item})

    if method == "GET" and path.startswith("/items/"):
        item_id = path_params.get("id") or path.split("/items/")[1]
        r = table.get_item(Key={"pk": item_id})
        return _resp(200, {"item": r.get("Item")})

    if method == "POST" and path == "/events":
        body = _parse_json(event.get("body"))
        sqs.send_message(QueueUrl=QUEUE_URL, MessageBody=json.dumps(body))
        return _resp(202, {"enqueued": True})

    return _resp(404, {"error": "not found"})

def handle_direct(event):
    cmd = (event or {}).get("cmd")

    if cmd == "create_item":
        item_id = str(uuid.uuid4())
        data = (event or {}).get("data", {})
        table.put_item(Item={"pk": item_id, "data": data})
        return _resp(201, {"id": item_id})

    if cmd == "get_item":
        item_id = (event or {}).get("id")
        r = table.get_item(Key={"pk": item_id})
        return _resp(200, {"item": r.get("Item")})

    if cmd == "enqueue_event":
        payload = (event or {}).get("payload", {})
        sqs.send_message(QueueUrl=QUEUE_URL, MessageBody=json.dumps(payload))
        return _resp(202, {"enqueued": True})

    return _resp(400, {"error": "unknown cmd"})

def lambda_handler(event, context):
    if _is_http_event(event):
        return handle_http(event)
    return handle_direct(event)