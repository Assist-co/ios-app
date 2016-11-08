# ios-app

## Summary
We're building a service that matches our users (clients) with their own personal assistants. A client can use our mobile app to easily interface with their assigned assistant while on the go. Assistants can perform tasks including but not limited to making calls, sending emails, scheduling meetings, making purchases, and conducting general research. Our app keeps track of tasks and provides convenient ways to communicate with one's assistant, including voice-to-text functionality.

## Target Audience
Now more than ever, professionals and millenials are outsourcing many of their day-to-day tasks to services like Instacart, Washio, Task Rabbit, Munchery, and Door Dash. A premium has been placed on reclaiming time from menial activities. We feel that there is an ample market for people who either do not need or cannot afford a full time secretary yet would benefit from the outsourcing of secretarial tasks. Providing a mobile solution to this problem allows us to allocate one secretary accross multiple people who do not need the fulltime services of a secretary.

## Wireframes
<a href=https://docs.google.com/presentation/d/1clFVoBxTCguYGYbkFs_5sm1adMRyEUzp00cjYRPt-og/edit?usp=sharing>Wireframes Link</a>

## User Stories

### Sprint 1

#### Backend
- [ ] Client (Create, Update, Get) and Assistant (Get) API 
- [ ] Message API (Fetch, Create)
- [ ] Task API (Fetch, Update, Create)
- [ ] Lightweight admin interface for viewing, updating, and creating clients, assistants, messages, and tasks
- [ ] Deploy backend

#### App
- [ ] Client, Assistant, Message, and Task model stubs
- [ ] Voice to text functionality
- [ ] API endpoints for Client, Assistant, Message, Task, and Voice-to-Text
- [ ] Task manager screen (Consider Yelp's interface for listing and mapping businesses on their search page)
   - [ ] Displays queued and pending tasks
   - [ ] Allows deletion/acceptance of tasks
- [ ] Messages screen
   - [ ] Button/functionality to call personal secretary
   - [ ] Button/functionality to pull up keyboard to type message
   - [ ] Button/functionality to record voice-to-text messages
- [ ] Message detail popover
   - [ ] Can view and edit message
- [ ] Onboarding Flow


### Future Sprints

#### App
- [ ] Settings screen
- [ ] User authentication (Session, Login, Logout)
- [ ] Task map view
- [ ] Can tag tasks on message detail popover screen

#### Backend or Frontend TBD
- [ ] Email integration
- [ ] Contacts integration
