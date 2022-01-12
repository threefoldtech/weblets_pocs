import { RouteRecordRaw } from 'vue-router';
import Home from '@/views/Home.vue';
import Login from '@/views/Login.vue';
import Callback from '@/views/Callback.vue';
import PathNotFound from '@/views/PathNotFound.vue';

export const routes: RouteRecordRaw[] = [
    {
        path: '/',
        name: 'home',
        component: Home,
        beforeEnter: (to, from, next) => {
            // We cant render this page without the correct information from the login
            if (!localStorage.getItem('profile')) {
                next({ name: 'login' });
                return;
            }

            next();
        },
    },
    {
        path: '/login',
        name: 'login',
        component: Login,
    },
    {
        path: '/callback',
        name: 'callback',
        component: Callback,
    },
    {
        path: '/404',
        name: '404',
        component: PathNotFound,
        // Allows props to be passed to the 404 page through route
        // params, such as `resource` to define what wasn't found.
        props: true,
    },
    {
        path: '/:pathMatch(.*)',
        redirect: '404',
    },
];
