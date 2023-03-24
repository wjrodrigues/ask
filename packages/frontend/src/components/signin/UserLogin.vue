<template>
  <v-card class="mx-auto" width="344" :title="$t('signin.form.title')">
    <v-container>
      <v-form v-model="form" @submit.prevent="onSubmit">
        <v-text-field
          v-model="email"
          :readonly="loading"
          :rules="[required]"
          clearable
          type="email"
          label="Email"
          variant="underlined"
          :error-messages="errors.email"
          name="email"
        ></v-text-field>

        <v-text-field
          v-model="password"
          :readonly="loading"
          :rules="[required]"
          clearable
          :label="$t('user.password')"
          type="password"
          variant="underlined"
          :error-messages="errors.password"
          name="password"
        ></v-text-field>

        <v-card-actions>
          <v-row justify="space-between">
            <v-btn variant="text" :disabled="loading" @click="goSignUp">
              {{ $t("signup.title") }}
            </v-btn>

            <v-btn
              type="submit"
              :disabled="loading"
              :loading="loading"
              color="info"
            >
              {{ $t("form.send") }}
            </v-btn>
          </v-row>
        </v-card-actions>
      </v-form>
    </v-container>
  </v-card>
</template>

<script lang="ts">
import { auth } from "@/service/auth";

export default {
  data: () => ({
    form: false,
    email: null,
    password: null,
    loading: false,
    errors: { email: "", password: "" },
  }),
  methods: {
    async onSubmit() {
      this.cleanError();
      this.loading = true;

      const response = await auth(`${this.email}`, `${this.password}`);
      if (response) return this.$router.push("/profile");

      this.setErrors();
    },
    required(value: String) {
      return !!value || this.$t("form.field_required");
    },
    cleanError() {
      this.errors = { email: "", password: "" };
    },
    setErrors() {
      this.loading = false;
      this.errors = {
        email: this.$t("form.invalid_data"),
        password: this.$t("form.invalid_data"),
      };
    },
    goSignUp() {
      this.$router.push("/signup");
    },
  },
};
</script>
