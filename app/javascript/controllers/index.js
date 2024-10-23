// Import and register all your controllers from the importmap under controllers/*
import { application } from "controllers/application"

// Eager load all controllers defined in the import map under controllers/**/*_controller
import { eagerLoadControllersFrom } from "@hotwired/stimulus-loading"
eagerLoadControllersFrom("controllers", application)

// Register FlashController
import FlashController from "./flash_controller"
application.register("flash", FlashController)

// Optionally, lazy load controllers as they appear in the DOM
// Remember: Don't preload controllers in the import map if you enable lazy loading!
// import { lazyLoadControllersFrom } from "@hotwired/stimulus-loading"
// lazyLoadControllersFrom("controllers", application)
