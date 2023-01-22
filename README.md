# Applications - Task List "ToDo-Ro"
<code><img height="500" src="https://user-images.githubusercontent.com/108235206/213916436-3ffbaa50-9e4b-4f06-9e72-15e21e867fca.png"></code>

<img align="right" alt="GIF" src="https://user-images.githubusercontent.com/108235206/211651526-f1a68b20-b12d-4ade-8821-2ce1b58913d0.gif?raw=true" width="250" />

Technologies:
CoreDate, MVVM, programmatically only, Gif, AlertController, CoreAnimation, Unit-test, Generic box

Details:
- memory used - CoreDate,
- architectural pattern - MVVM,
- application without StoryBoard and XIB. Programmatically only,
- two screens,
- adding and editing tasks using AlertController,
- two types of sorting by date and name,
- sorting up and down by pressing the button again,
- added gif animation after LaunchScreen,
- additional menu when swiping left (Delete, Edit, Done \ Cancel),
- implemented the logic for executing tasks by the done button,
- a simple click on a task will change its status,
- the main screen shows the number of current tasks and the creation date,
- used the CoreAnimation on the counter, when all completed tasks show fire, if there is no task, the counter is not shown,
- when you click "Complete" in the task list, all tasks automatically change to the "Completed" status,
- added Unit tests for CoreData, First Screen, Second Screen,
- when there is no task list, the sort buttons are hidden and a background image is shown,
- with a light or dark theme, the background of the application changes.

<code><img height="500" src="https://user-images.githubusercontent.com/108235206/213916703-d7f4372f-cc93-4b05-93dd-82ca807b3028.png"></code>

When the task list is empty, the background image appears on the screen and the sort buttons disappear.

If you click Edit, the Add button will become inactive.

<code><img height="500" src="https://user-images.githubusercontent.com/108235206/213917426-abcb8ab5-4c39-480b-8d16-db798671887c.png"></code>

To understand up or down sorting, when pressed, an arrow appears showing the direction

<code><img height="500" src="https://user-images.githubusercontent.com/108235206/213917546-bdbf0ddd-cd2e-4601-b2cd-e92dd52540f2.png"></code>

When adding or changing a task, a pop-up alert with two buttons is called(Cencel, Save\Edit)
And until a name for the task is specified, the add button will be inactive.

<code><img height="500" src="https://user-images.githubusercontent.com/108235206/213917670-232f6130-1c0f-4334-ad61-795469543b69.png"></code> 

On the first screen, the logic of sorting by buttons is implemented, and on the second screen, it is implemented by completed or not completed; 

When the task status changes, it smoothly goes to its section.

<code><img height="500" src="https://user-images.githubusercontent.com/108235206/213917866-4066e871-1449-4236-a761-3b8fc7e63bb7.png"></code> 
