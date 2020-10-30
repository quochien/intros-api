
```
curl "http://localhost:3000/copy"

{"intro.created_at":"Intro created on Tue Oct 27 03:56:55 PM","greeting":"Hi {name}, welcome to {app}!"}
```

```
curl "http://localhost:3000/copy/greeting?name=John&app=Bridge"

{"value":"Hi John, welcome to Bridge!"}
```

```
curl "http://localhost:3000/copy/intro.created_at?created_at=1603814215"

{"value":"Intro created on Tue Oct 27 03:56:55 PM"}
```

```
curl "http://localhost:3000/copy/refresh"

{"bye":"Goodbye","intro.created_at":"Intro created on {created_at, datetime}","greeting":"Hello {name}, welcome to {app}!"}
```

```
curl "http://localhost:3000/copy?since=1604072183"

{"bye":"Goodbye","greeting":"Hello {name}, welcome to {app}!"}
```

```
curl "http://localhost:3000/copy/bye"

{"value":"Goodbye"}%
```
