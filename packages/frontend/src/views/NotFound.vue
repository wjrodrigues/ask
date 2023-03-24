<template>
  <div class="h-screen">
    <div class="d-flex align-center justify-center h-75">
      <v-container class="w-auto">
        <v-row>
          <v-col>
            <p class="message">404 | {{ $t("pages.not_found.title") }}</p>
          </v-col>
        </v-row>

        <v-row>
          <v-col class="d-flex justify-center">
            <router-link to="/">
              <v-btn variant="text"> {{ $t("pages.not_found.home") }} </v-btn>
            </router-link>
          </v-col>
        </v-row>
      </v-container>
    </div>
  </div>
</template>

<script lang="ts">
export default {
  components: {},
};
</script>

<style>
.message {
  font-size: xx-large;
}
</style>
