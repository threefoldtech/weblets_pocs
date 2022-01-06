<svelte:options tag="tf-template" />

<script lang="ts">
  export let name: string;
</script>

<p>
  hello, <span>{name}</span>.
</p>

<style lang="scss" scoped>
  p {
    padding: 15px;

    span {
      font-family: sans-serif;
      color: red;
    }
  }
</style>
