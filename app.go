package main

import "github.com/whobrokethebuild/goingup"

func main() {
	app := goingup.NewApp()
	app.Options.Port = 8080

	app.AddPage("/", "Home", "page", "home")
	app.AddPage("/resume", "Resume", "page", "resume")
	app.AddPage("/projects", "Projects", "page", "projects")

	app.Options.Menus["Main"] = []goingup.MenuItem{
		{URL: "/", Text: "Home"},
		{URL: "/resume", Text: "Resume"},
		{URL: "/projects", Text: "Projects"},
	}

	app.Run()
}
