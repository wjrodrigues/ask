import { createRouter, createWebHistory } from "vue-router";
import Signup from "../views/Signup.vue"

const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes: [
    {
      path: "/signup",
      name: "Sign up",
      component: () => Signup,
      meta: {
        title: 'signup.title'
      },
    }
  ],
});

export default router;
