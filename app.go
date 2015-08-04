package main

import "github.com/whobrokethebuild/goingup"

func main() {
	app := goingup.NewApp()
	app.Options.Port = 8080

	app.AddPage(goingup.NewPage("/", "Home", "page", "home"))
	app.AddPage(goingup.NewPage("/", "Home", "page", "home"))
	app.AddPage(goingup.NewPage("/resume", "Resume", "page", "resume"))
	app.AddPage(goingup.NewPage("/projects", "Projects", "page", "projects"))

	mainMenu := goingup.NewMenu();
	mainMenu.AddItem(goingup.NewMenuItem("/", "Home"))
	mainMenu.AddItem(goingup.NewMenuItem("/resume", "Resume"))
	mainMenu.AddItem(goingup.NewMenuItem("/projects", "Projects"))
	app.AddMenu("main", mainMenu)

	app.Run()
}
