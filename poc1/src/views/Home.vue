<template>
    <div class="relative h-screen flex overflow-hidden bg-white">
        <TransitionRoot as="template" :show="sidebarOpen">
            <Dialog as="div" class="fixed inset-0 flex z-40 lg:hidden" @close="sidebarOpen = false">
                <TransitionChild
                    as="template"
                    enter="transition-opacity ease-linear duration-300"
                    enter-from="opacity-0"
                    enter-to="opacity-100"
                    leave="transition-opacity ease-linear duration-300"
                    leave-from="opacity-100"
                    leave-to="opacity-0"
                >
                    <DialogOverlay class="fixed inset-0 bg-gray-600 bg-opacity-75" />
                </TransitionChild>
                <TransitionChild
                    as="template"
                    enter="transition ease-in-out duration-300 transform"
                    enter-from="-translate-x-full"
                    enter-to="translate-x-0"
                    leave="transition ease-in-out duration-300 transform"
                    leave-from="translate-x-0"
                    leave-to="-translate-x-full"
                >
                    <div class="relative flex-1 flex flex-col max-w-xs w-full pt-5 pb-4 bg-white">
                        <TransitionChild
                            as="template"
                            enter="ease-in-out duration-300"
                            enter-from="opacity-0"
                            enter-to="opacity-100"
                            leave="ease-in-out duration-300"
                            leave-from="opacity-100"
                            leave-to="opacity-0"
                        >
                            <div class="absolute top-0 right-0 -mr-12 pt-2">
                                <button
                                    type="button"
                                    class="
                                        ml-1
                                        flex
                                        items-center
                                        justify-center
                                        h-10
                                        w-10
                                        rounded-full
                                        focus:outline-none focus:ring-2 focus:ring-inset focus:ring-white
                                    "
                                    @click="sidebarOpen = false"
                                >
                                    <span class="sr-only">Close sidebar</span>
                                    <XIcon class="h-6 w-6 text-white" aria-hidden="true" />
                                </button>
                            </div>
                        </TransitionChild>
                        <div class="flex-shrink-0 flex items-center px-4">
                            <img class="h-8 w-auto" src="/threefold_banner.jpg" alt="Workflow" />
                        </div>
                        <div class="mt-5 flex-1 h-0 overflow-y-auto">
                            <nav class="px-2">
                                <div class="space-y-1">
                                    <a
                                        v-for="item in navigation"
                                        :key="item.name"
                                        :href="item.href"
                                        :class="[
                                            item.current
                                                ? 'bg-gray-100 text-gray-900'
                                                : 'text-gray-600 hover:text-gray-900 hover:bg-gray-50',
                                            'group flex items-center px-2 py-2 text-base leading-5 font-medium rounded-md',
                                        ]"
                                        :aria-current="item.current ? 'page' : undefined"
                                    >
                                        <component
                                            :is="item.icon"
                                            :class="[
                                                item.current
                                                    ? 'text-gray-500'
                                                    : 'text-gray-400 group-hover:text-gray-500',
                                                'mr-3 flex-shrink-0 h-6 w-6',
                                            ]"
                                            aria-hidden="true"
                                        />
                                        {{ item.name }}
                                    </a>
                                </div>
                            </nav>
                        </div>
                    </div>
                </TransitionChild>
                <div class="flex-shrink-0 w-14" aria-hidden="true">
                    <!-- Dummy element to force sidebar to shrink to fit close icon -->
                </div>
            </Dialog>
        </TransitionRoot>

        <!-- Static sidebar for desktop -->
        <div class="hidden lg:flex lg:flex-shrink-0">
            <div class="flex flex-col w-64 border-r border-gray-200 pt-5 pb-4 bg-gray-100">
                <div class="flex items-center flex-shrink-0 px-6">
                    <img class="h-8 w-auto" src="/threefold.svg" alt="Workflow" />
                </div>
                <!-- Sidebar component, swap this element with another sidebar if you like -->
                <div class="h-0 flex-1 flex flex-col overflow-y-auto">
                    <!-- User account dropdown -->
                    <Menu as="div" class="px-3 mt-6 relative inline-block text-left">
                        <div>
                            <MenuButton
                                class="
                                    group
                                    w-full
                                    bg-gray-100
                                    rounded-md
                                    px-3.5
                                    py-2
                                    text-sm text-left
                                    font-medium
                                    text-gray-700
                                    hover:bg-gray-200
                                    focus:outline-none
                                    focus:ring-2
                                    focus:ring-offset-2
                                    focus:ring-offset-gray-100
                                    focus:ring-purple-500
                                "
                            >
                                <span class="flex w-full justify-between items-center">
                                    <span class="flex min-w-0 items-center justify-between space-x-3">
                                        <img
                                            class="w-10 h-10 bg-gray-300 rounded-full flex-shrink-0"
                                            src="https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=facearea&facepad=2&w=256&h=256&q=80"
                                            alt=""
                                        />
                                        <span class="flex-1 flex flex-col min-w-0">
                                            <span class="text-gray-900 text-sm font-medium truncate">{{
                                                profile.doubleName
                                            }}</span>
                                            <span class="text-gray-500 text-sm truncate"
                                                >@{{ profile.email.email }}</span
                                            >
                                        </span>
                                    </span>
                                    <SelectorIcon
                                        class="flex-shrink-0 h-5 w-5 text-gray-400 group-hover:text-gray-500"
                                        aria-hidden="true"
                                    />
                                </span>
                            </MenuButton>
                        </div>
                        <transition
                            enter-active-class="transition ease-out duration-100"
                            enter-from-class="transform opacity-0 scale-95"
                            enter-to-class="transform opacity-100 scale-100"
                            leave-active-class="transition ease-in duration-75"
                            leave-from-class="transform opacity-100 scale-100"
                            leave-to-class="transform opacity-0 scale-95"
                        >
                            <MenuItems
                                class="
                                    z-10
                                    mx-3
                                    origin-top
                                    absolute
                                    right-0
                                    left-0
                                    mt-1
                                    rounded-md
                                    shadow-lg
                                    bg-white
                                    ring-1 ring-black ring-opacity-5
                                    divide-y divide-gray-200
                                    focus:outline-none
                                "
                            >
                                <div class="py-1">
                                    <MenuItem v-slot="{ active }">
                                        <a
                                            @click="logout"
                                            href="#"
                                            :class="[
                                                active ? 'bg-gray-100 text-gray-900' : 'text-gray-700',
                                                'block px-4 py-2 text-sm',
                                            ]"
                                            >Logout</a
                                        >
                                    </MenuItem>
                                </div>
                            </MenuItems>
                        </transition>
                    </Menu>
                    <!-- Navigation -->
                    <nav class="px-3 mt-6">
                        <div class="space-y-1">
                            <a
                                v-for="item in navigation"
                                :key="item.name"
                                :href="item.href"
                                :class="[
                                    item.current
                                        ? 'bg-gray-200 text-gray-900'
                                        : 'text-gray-700 hover:text-gray-900 hover:bg-gray-50',
                                    'group flex items-center px-2 py-2 text-sm font-medium rounded-md',
                                ]"
                                :aria-current="item.current ? 'page' : undefined"
                            >
                                <component
                                    :is="item.icon"
                                    :class="[
                                        item.current ? 'text-gray-500' : 'text-gray-400 group-hover:text-gray-500',
                                        'mr-3 flex-shrink-0 h-6 w-6',
                                    ]"
                                    aria-hidden="true"
                                />
                                {{ item.name }}
                            </a>
                        </div>
                    </nav>
                </div>
            </div>
        </div>
        <!-- Main column -->
        <div class="flex flex-col w-0 flex-1 overflow-hidden">
            <!-- Search header -->
            <div class="relative z-10 flex-shrink-0 flex h-16 bg-white border-b border-gray-200 lg:hidden">
                <button
                    type="button"
                    class="
                        px-4
                        border-r border-gray-200
                        text-gray-500
                        focus:outline-none focus:ring-2 focus:ring-inset focus:ring-purple-500
                        lg:hidden
                    "
                    @click="sidebarOpen = true"
                >
                    <span class="sr-only">Open sidebar</span>
                    <MenuAlt1Icon class="h-6 w-6" aria-hidden="true" />
                </button>
                <div class="flex-1 flex justify-between px-4 sm:px-6 lg:px-8">
                    <div class="flex items-center">
                        <!-- Profile dropdown -->
                        <Menu as="div" class="ml-3 relative">
                            <div>
                                <MenuButton
                                    class="
                                        max-w-xs
                                        bg-white
                                        flex
                                        items-center
                                        text-sm
                                        rounded-full
                                        focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-purple-500
                                    "
                                >
                                    <span class="sr-only">Open user menu</span>
                                    <img
                                        class="h-8 w-8 rounded-full"
                                        src="https://images.unsplash.com/photo-1502685104226-ee32379fefbe?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=facearea&facepad=2&w=256&h=256&q=80"
                                        alt=""
                                    />
                                </MenuButton>
                            </div>
                            <transition
                                enter-active-class="transition ease-out duration-100"
                                enter-from-class="transform opacity-0 scale-95"
                                enter-to-class="transform opacity-100 scale-100"
                                leave-active-class="transition ease-in duration-75"
                                leave-from-class="transform opacity-100 scale-100"
                                leave-to-class="transform opacity-0 scale-95"
                            >
                                <MenuItems
                                    class="
                                        origin-top-right
                                        absolute
                                        right-0
                                        mt-2
                                        w-48
                                        rounded-md
                                        shadow-lg
                                        bg-white
                                        ring-1 ring-black ring-opacity-5
                                        divide-y divide-gray-200
                                        focus:outline-none
                                    "
                                >
                                    <div class="py-1">
                                        <MenuItem v-slot="{ active }">
                                            <a
                                                href="#"
                                                :class="[
                                                    active ? 'bg-gray-100 text-gray-900' : 'text-gray-700',
                                                    'block px-4 py-2 text-sm',
                                                ]"
                                                >View profile</a
                                            >
                                        </MenuItem>
                                        <MenuItem v-slot="{ active }">
                                            <a
                                                href="#"
                                                :class="[
                                                    active ? 'bg-gray-100 text-gray-900' : 'text-gray-700',
                                                    'block px-4 py-2 text-sm',
                                                ]"
                                                >Settings</a
                                            >
                                        </MenuItem>
                                        <MenuItem v-slot="{ active }">
                                            <a
                                                href="#"
                                                :class="[
                                                    active ? 'bg-gray-100 text-gray-900' : 'text-gray-700',
                                                    'block px-4 py-2 text-sm',
                                                ]"
                                                >Notifications</a
                                            >
                                        </MenuItem>
                                    </div>
                                    <div class="py-1">
                                        <MenuItem v-slot="{ active }">
                                            <a
                                                href="#"
                                                :class="[
                                                    active ? 'bg-gray-100 text-gray-900' : 'text-gray-700',
                                                    'block px-4 py-2 text-sm',
                                                ]"
                                                >Get desktop app</a
                                            >
                                        </MenuItem>
                                        <MenuItem v-slot="{ active }">
                                            <a
                                                href="#"
                                                :class="[
                                                    active ? 'bg-gray-100 text-gray-900' : 'text-gray-700',
                                                    'block px-4 py-2 text-sm',
                                                ]"
                                                >Support</a
                                            >
                                        </MenuItem>
                                    </div>
                                    <div class="py-1">
                                        <MenuItem v-slot="{ active }">
                                            <a
                                                href="#"
                                                :class="[
                                                    active ? 'bg-gray-100 text-gray-900' : 'text-gray-700',
                                                    'block px-4 py-2 text-sm',
                                                ]"
                                                >Logout</a
                                            >
                                        </MenuItem>
                                    </div>
                                </MenuItems>
                            </transition>
                        </Menu>
                    </div>
                </div>
            </div>
            <main class="flex-1 relative z-0 overflow-y-auto focus:outline-none">
                <!-- Page title & actions -->
                <div
                    class="
                        border-b border-gray-200
                        px-4
                        py-4
                        sm:flex sm:items-center sm:justify-between sm:px-6
                        lg:px-8
                    "
                >
                    <div class="flex-1 min-w-0">
                        <h1 class="text-lg font-medium leading-6 text-gray-900 sm:truncate">Pkid</h1>
                    </div>
                    <form @submit.prevent="getRow" style="border-right: black solid 2px; margin-right: 10px; padding: 10px;">

                        <div class="flex-1 relative z-0">
                            <input type="text" v-model="pkidData.getKey" placeholder="Get this key's value"/>
                            <br>
                            <button class="float-left bg-white hover:bg-gray-100 text-gray-800 font-semibold py-2 px-4 border border-gray-400 rounded shadow" type="submit">Get Value</button>
                        </div>
                    </form>

                    <form @submit.prevent="addRow">
                        <input type="text" v-model="pkidData.setKey" placeholder="Key" />
                        <input type="text" v-model="pkidData.setValue" placeholder="Value"/>
                        <br>
                        <button class="float-middle bg-white hover:bg-gray-100 text-gray-800 font-semibold py-2 px-4 border border-gray-400 rounded shadow" type="submit">Add or Update Key</button>
                    </form>
                      
                </div>

                <!-- Projects list (only on smallest breakpoint) -->
                <div class="mt-10 sm:hidden">
                    <div class="px-4 sm:px-6">
                        <h2 class="text-gray-500 text-xs font-medium uppercase tracking-wide">Key</h2>
                    </div>
                    <ul role="list" class="mt-3 border-t border-gray-200 divide-y divide-gray-100">
                        <li v-for="project in pkidData.data" :key="project.id">
                            <a
                                href="#"
                                class="group flex items-center justify-between px-4 py-4 hover:bg-gray-50 sm:px-6"
                            >
                                <span class="flex items-center truncate space-x-3">
                                    <span
                                        :class="[project.bgColorClass, 'w-2.5 h-2.5 flex-shrink-0 rounded-full']"
                                        aria-hidden="true"
                                    />
                                    <span class="font-medium truncate text-sm leading-6">
                                        {{ project.title }}
                                        {{ ' ' }}
                                        <span class="truncate font-normal text-gray-500">in {{ project.team }}</span>
                                    </span>
                                </span>
                                <ChevronRightIcon
                                    class="ml-4 h-5 w-5 text-gray-400 group-hover:text-gray-500"
                                    aria-hidden="true"
                                />
                            </a>
                        </li>
                    </ul>
                </div>

                <!-- Projects table (small breakpoint and up) -->
                <div class="hidden mt-8 sm:block">
                    <div class="align-middle inline-block min-w-full border-b border-gray-200">
                        <table class="min-w-full">
                            <thead>
                                <tr class="border-t border-gray-200">
                                    <th
                                        class="
                                            px-6
                                            py-3
                                            border-b border-gray-200
                                            bg-gray-50
                                            text-left text-xs
                                            font-medium
                                            text-gray-500
                                            uppercase
                                            tracking-wider
                                        "
                                    >
                                        <span class="lg:pl-2">Key</span>
                                    </th>
                                    <th
                                        class="
                                            px-6
                                            py-3
                                            border-b border-gray-200
                                            bg-gray-50
                                            text-left text-xs
                                            font-medium
                                            text-gray-500
                                            uppercase
                                            tracking-wider
                                        "
                                    >
                                        Value
                                    </th>
                                    <th
                                        class="
                                            pr-6
                                            py-3
                                            border-b border-gray-200
                                            bg-gray-50
                                            text-right text-xs
                                            font-medium
                                            text-gray-500
                                            uppercase
                                            tracking-wider
                                        "
                                    />
                                </tr>
                            </thead>
                            <tbody class="bg-white divide-y divide-gray-100">
                                <tr v-for="project in pkidData.data" :key="project.id">
                                    <td class="px-6 py-3 max-w-0 whitespace-nowrap text-sm font-medium text-gray-900">
                                        <div class="flex items-center space-x-3 lg:pl-2">
                                            <div
                                                :class="[
                                                    project.bgColorClass,
                                                    'flex-shrink-0 w-2.5 h-2.5 rounded-full',
                                                ]"
                                                aria-hidden="true"
                                            />
                                            <a href="#" class="truncate hover:text-gray-600">
                                                <span>
                                                    {{ project.title }}
                                                </span>
                                            </a>
                                        </div>
                                    </td>
                                    <td class="px-6 py-3 text-sm text-gray-500 font-medium">
                                        <div class="flex items-center space-x-2">
                                            <div class="flex flex-shrink-0 -space-x-1">{{ project.value }}</div>
                                        </div>
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>
            </main>
        </div>
    </div>
</template>

<script lang="ts" setup>
import { ref, reactive } from 'vue';
import router from '../router/index';
import pkid from '@jimber/pkid';
import _sodium from 'libsodium-wrappers';
import {
    Dialog,
    DialogOverlay,
    Menu,
    MenuButton,
    MenuItem,
    MenuItems,
    TransitionChild,
    TransitionRoot,
} from '@headlessui/vue';
import { ClockIcon, HomeIcon, MenuAlt1Icon, ViewListIcon, XIcon, DatabaseIcon } from '@heroicons/vue/outline';
import {
    ChevronRightIcon,
    DotsVerticalIcon,
    DuplicateIcon,
    PencilAltIcon,
    SearchIcon,
    SelectorIcon,
    TrashIcon,
    UserAddIcon,
} from '@heroicons/vue/solid';

function Uint8ArrayFromBase64Url(base64Url: string) {
    return Uint8Array.from(window.atob(base64Url.replace(/-/g, '+').replace(/_/g, '/')), v => v.charCodeAt(0));
}

const logout = () => {
    localStorage.removeItem('profile');
    localStorage.removeItem('state');
    localStorage.removeItem('signedEmailIdentifier');
    localStorage.removeItem('signedPhoneIdentifier');

    router.push({ name: 'login' });
};
const navigation = [{ name: 'Pkid', href: '#', icon: DatabaseIcon, current: true }];
const teams = [];
let client: any;
let publicKey: Uint8Array;
let privateKey: Uint8Array;

const pkidData = reactive({
    data: [],
    setKey: "",
    setValue: "",
    getKey: ""
});

async function addRow() {
    console.log(await client.setDoc(pkidData.setKey, JSON.stringify(pkidData.setValue), true));
    pkidData.setKey = "";
    pkidData.setValue = "";
}
async function getRow() {
    const value = (await client.getDoc(publicKey, pkidData.getKey));
    console.log(pkidData.getKey)
    console.log(value);
    if(value.status != 404){
        pkidData.data = [
            ...pkidData.data,
            { id: pkidData.data.length, title: pkidData.getKey, value: value.data}
        ]
    }
}
const sidebarOpen = ref(false);

const profile = JSON.parse(localStorage.getItem('profile') as any).profile;

console.log(profile);

console.log('Waiting for sodium to be ready');

(async () => {
    await _sodium.ready;
    const sodium = _sodium;
    console.log('Sodium is ready?');

    // var key = sodium.randombytes_buf(sodium.crypto_shorthash_KEYBYTES);
    // console.log('KEY');
    // console.log(key);

    console.log('derivedSeed: ', Uint8ArrayFromBase64Url(profile.derivedSeed));
    const keyPair = sodium.crypto_sign_seed_keypair(Uint8ArrayFromBase64Url(profile.derivedSeed));
    console.log('done with keypair?');
    console.log('Keypair: ', keyPair.publicKey);
    console.log('Keypair: ', keyPair.privateKey);

    const url = 'https://pkid.staging.jimber.org';
    const _publicKey = keyPair.publicKey;
    const _privateKey = keyPair.privateKey;

    publicKey = _publicKey;
    privateKey = _privateKey;

    const _client = new pkid(url, keyPair);
    client = _client;
    console.log(_client);

})();

</script>

<style scoped></style>
