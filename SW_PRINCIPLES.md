# Software Engineering Principles & Best Practices (Full-Stack)

## 1. Fundamente de Inginerie Software

### SOLID
- **S**ingle Responsibility Principle (SRP)  
  → Un modul/clasă trebuie să aibă un singur motiv de schimbare.

- **O**pen/Closed Principle (OCP)  
  → Codul trebuie să fie extensibil fără modificări majore.

- **L**iskov Substitution Principle (LSP)  
  → Subclasele trebuie să poată înlocui clasele de bază fără efecte neașteptate.

- **I**nterface Segregation Principle (ISP)  
  → Interfețele trebuie să fie mici și specifice.

- **D**ependency Inversion Principle (DIP)  
  → Depinzi de abstracții, nu de implementări.

---

### DRY / KISS / YAGNI
- **DRY (Don't Repeat Yourself)**  
  → Evită duplicarea logicii.

- **KISS (Keep It Simple, Stupid)**  
  → Soluțiile simple sunt de preferat.

- **YAGNI (You Aren't Gonna Need It)**  
  → Nu implementa lucruri "pentru viitor" fără nevoie reală.

---

## 2. Arhitectură

### Separarea responsabilităților
- UI / Presentation Layer
- Business Logic Layer
- Data Access Layer

### Pattern-uri comune
- MVC / MVVM
- Clean Architecture
- Hexagonal (Ports & Adapters)
- Microservices vs Monolith (alegere în funcție de context)

### Reguli importante
- Low coupling, high cohesion
- Fără dependențe circulare
- Modularitate clară

---

## 3. Structurarea unui proiect Full Stack

### Frontend
- Structură pe features, nu doar pe tipuri (ex: `/features/auth`)
- Componente mici și reutilizabile
- State management clar (local vs global)
- Separare logică UI vs logică business

### Backend
- Controllers → doar orchestrare
- Services → logică business
- Repositories → acces DB
- DTOs pentru input/output

---

## 4. Clean Code

### Naming
- Variabile descriptive (`userEmail` > `x`)
- Funcții → verbe (`getUser`, `createOrder`)
- Clase → substantive (`UserService`)

### Funcții
- Mici (ideal < 20-30 linii)
- Un singur scop
- Fără side-effects neașteptate

### Cod lizibil
- Evită nested hell
- Early returns
- Evită magic numbers

---

## 5. Git & Version Control

### Reguli de bază
- Commits mici și descriptive
- Branching:
  - `main` (prod)
  - `dev`
  - `feature/*`
  - `fix/*`

### Mesaje commit
- `feat: add login endpoint`
- `fix: resolve token bug`
- `refactor: simplify auth logic`

---

## 6. Testing

### Tipuri
- Unit tests (logică)
- Integration tests (API + DB)
- E2E tests (flow complet)

### Best practices
- Teste rapide și independente
- Mock externals (API, DB)
- Coverage util, nu obsesiv

---

## 7. Security

### Backend
- Validare input (niciodată trust client)
- Sanitizare
- Rate limiting
- Auth + authZ corecte
- Nu expune stack traces

### Frontend
- Nu stoca token-uri sensibile în localStorage (prefer httpOnly cookies)
- Protecție XSS / CSRF

---

## 8. Performance

### Frontend
- Lazy loading
- Code splitting
- Memoization
- Evită re-render-uri inutile

### Backend
- Caching (Redis etc.)
- Query-uri optimizate
- Indexuri DB
- Pagination (niciodată fetch all)

---

## 9. Database Design

- Normalizare (dar nu excesivă)
- Indexuri pe coloane frecvent folosite
- Evită N+1 queries
- Folosește migrations

---

## 10. API Design

### REST
- `/users` → GET, POST
- `/users/:id` → GET, PUT, DELETE

### Reguli
- Status codes corecte
- Răspunsuri consistente
- Versionare API (`/v1/`)

---

## 11. DevOps & Deployment

- CI/CD (GitHub Actions, etc.)
- Environment separation:
  - dev
  - staging
  - production
- Secrets management (nu în repo)
- Logging + monitoring

---

## 12. Observability

- Logging structurat
- Error tracking
- Metrics (CPU, memory, latency)
- Alerts

---

## 13. Scalability

- Stateless backend
- Horizontal scaling
- Load balancing
- Queue systems (jobs async)

---

## 14. Code Review

- Fără ego
- Focus pe:
  - claritate
  - performanță
  - securitate
- Nu aproba fără să înțelegi codul

---

## 15. Anti-Patterns de evitat

- God classes
- Spaghetti code
- Over-engineering
- Premature optimization
- Copy-paste coding

---

## 16. Mindset de Senior

- Optimizezi pentru mentenanță, nu doar pentru "merge"
- Scrii cod pentru alții, nu pentru tine
- Gândești în sisteme, nu doar în funcții
- Îți pui întrebări:
  - "Ce se întâmplă la scale?"
  - "Ce se întâmplă dacă pică?"
  - "Cum testez asta?"

---

## 17. Checklist rapid (daily use)

- [ ] Codul e simplu?
- [ ] E ușor de înțeles?
- [ ] Are sens structura?
- [ ] E testabil?
- [ ] E securizat?
- [ ] E performant suficient?
- [ ] Nu am over-engineered?
