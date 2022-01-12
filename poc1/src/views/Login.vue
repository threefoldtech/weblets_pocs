<template>
    <div class="min-h-screen bg-white flex">
        <div class="flex-1 flex flex-col justify-center py-12 px-4 sm:px-6 lg:flex-none lg:px-20 xl:px-24">
            <div class="mx-auto w-full max-w-sm lg:w-96">
                <div>
                    <img class="h-12 w-auto" src="/icon.svg" alt="Workflow" />
                    <h2 class="mt-6 text-3xl font-extrabold text-gray-900">Login with</h2>
                </div>

                <div class="mt-8">
                    <div>
                        <div>
                            <p class="text-sm font-medium text-gray-700">your threefold connect app</p>

                            <div @click="initiateLoginFlow" class="mt-1 grid gap-3">
                                <div>
                                    <a
                                        href="#"
                                        class="
                                            w-full
                                            inline-flex
                                            justify-center
                                            py-2
                                            px-4
                                            border border-gray-300
                                            rounded-md
                                            shadow-sm
                                            bg-white
                                            text-sm
                                            font-medium
                                            text-gray-500
                                            hover:bg-gray-50
                                        "
                                    >
                                        <img src="/icon.svg" width="30" alt="" />
                                    </a>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="hidden lg:block relative w-0 flex-1">
            <img class="absolute inset-0 h-full w-full object-cover" src="/threefold_banner.jpg" alt="" />
        </div>
    </div>
</template>

<script lang="ts" setup>
    import { generateRandomString, ThreefoldLogin } from '@threefoldjimber/threefold_login/dist';
    import { onMounted, onUpdated, onUnmounted } from 'vue';
    import router from '../router/index';

    onMounted(() => {
        console.log('mounted!');
    });

    const popupCenter = (url: string, title: string, w: number, h: number) => {
        // Fixes dual-screen position                             Most browsers      Firefox
        const dualScreenLeft = window.screenLeft !== undefined ? window.screenLeft : window.screenX;
        const dualScreenTop = window.screenTop !== undefined ? window.screenTop : window.screenY;
        const width = window.innerWidth
            ? window.innerWidth
            : document.documentElement.clientWidth
            ? document.documentElement.clientWidth
            : screen.width;
        const height = window.innerHeight
            ? window.innerHeight
            : document.documentElement.clientHeight
            ? document.documentElement.clientHeight
            : screen.height;
        const systemZoom = width / window.screen.availWidth;
        const left = (width - w) / 2 / systemZoom + dualScreenLeft;
        const top = (height - h) / 2 / systemZoom + dualScreenTop;
        const newWindow = window.open(
            url,
            title,
            `
      scrollbars=yes,
      width=${w / systemZoom},
      height=${h / systemZoom},
      top=${top},
      left=${left}
      `
        );
        if (newWindow) newWindow.focus();
        return newWindow;
    };

    const initiateLoginFlow = async () => {
        const threeFoldAPIHost = 'https://login.threefold.me';
        const appId = window.location.host;
        const seedPhrase =
            'calm science teach foil burst until next mango hole sponsor fold bottom cousin push focus track truly tornado turtle over tornado teach large fiscal';
        const redirectUrl = '/callback';

        console.log('seedPhrase: ', seedPhrase);
        const _login = new ThreefoldLogin(
            threeFoldAPIHost,
            appId,
            seedPhrase,
            redirectUrl,
            'https://openkyc.live'
        );
        await _login.init();
        console.log('Await done ?');
        const state = generateRandomString(32);
        console.log('state?????? ', state);

        // @ts-ignore
        window.localStorage.setItem('state', state);

        // @ts-ignore
        const loginUrl = _login.generateLoginUrl(state, {
            scope: JSON.stringify({ email: true, phone: true, derivedSeed: true }),
        });

        console.log('loginUrl: ', loginUrl);

        const popup = popupCenter(loginUrl, 'Threefold login', 800, 550);
        console.log('popup: ', popup);

        window.onmessage = async (e: MessageEvent) => {
            if (e.data.message === 'threefoldLoginRedirectSuccess') {
                let profile = e.data.profileData;
                console.log('e.data.profileData: ', e.data.profileData);
                window.localStorage.setItem('profile', JSON.stringify(e.data.profileData));
                const sei = e.data.profileData?.profile?.email?.sei;
                if (sei) {
                    console.log('SEI. ', sei);
                    let signedEmailIdentifier = await _login.verifySignedEmailIdenfier(sei);
                    window.localStorage.setItem('signedEmailIdentifier', JSON.stringify(signedEmailIdentifier));
                    console.log('signedEmailIdentifier: ', signedEmailIdentifier);
                }
                const spi = e.data.profileData?.profile?.email?.spi;
                if (spi) {
                    console.log('SPI. ', spi);
                    let signedPhoneIdentifier = await _login.verifySignedPhoneIdenfier(spi);
                    window.localStorage.setItem('signedPhoneIdentifier', JSON.stringify(signedPhoneIdentifier));
                    console.log('signedPhoneIdentifier: ', signedPhoneIdentifier);
                }
                popup?.close();
                router.push({ name: 'home' });
            }
            else {
                console.log('e.data.message: ', e.data.message);
            }
        };
    };
</script>

<style scoped></style>
