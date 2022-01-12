<template>
    <div>Callback</div>
</template>

<script lang="ts" setup>
    import { ThreefoldLogin, generateRandomString } from '@threefoldjimber/threefold_login/dist';

    const threeFoldAPIHost = 'https://login.threefold.me';
    const appId = window.location.host;
    const seedPhrase =
        'calm science teach foil burst until next mango hole sponsor fold bottom cousin push focus track truly tornado turtle over tornado teach large fiscal';
    const _redirectUrl = '/callback';

    console.log('seedPhrase: ', seedPhrase);
    const _login = new ThreefoldLogin(
        threeFoldAPIHost,
        appId,
        seedPhrase,
        _redirectUrl,
        'https://openkyc.live'
    );
    await _login.init();

    const state = window.localStorage.getItem('state') as string;
    const redirectUrl = new URL(window.location.href);

    try {
        const profileData = await _login.parseAndValidateRedirectUrl(redirectUrl, state);
        window.opener.postMessage({ message: 'threefoldLoginRedirectSuccess', profileData: profileData });
        console.log(profileData);
    } catch (e) {
        console.error('Error', e);
    }
</script>
