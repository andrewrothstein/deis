// +build integration

package tests

import (
	"io/ioutil"
	"testing"

	"github.com/deis/deis/tests/utils"
)

var (
	configListCmd         = "config:list --app={{.AppName}}"
	configSetCmd          = "config:set FOO=讲台 --app={{.AppName}}"
	configSet2Cmd         = "config:set FOO=10 --app={{.AppName}}"
	configSet3Cmd         = "config:set POWERED_BY=\"the Deis team\" --app={{.AppName}}"
	configSetBuildpackCmd = "config:set BUILDPACK_URL=https://github.com/heroku/heroku-buildpack-go#98f37cc --app={{.AppName}}"
	configUnsetCmd        = "config:unset FOO --app={{.AppName}}"
)

func TestConfig(t *testing.T) {
	params := configSetup(t)
	configSetTest(t, params)
	configPushTest(t, params)
	configListTest(t, params, false)
	appsOpenTest(t, params)
	configUnsetTest(t, params)
	configListTest(t, params, true)
	limitsSetTest(t, params, 4)
	appsOpenTest(t, params)
	limitsUnsetTest(t, params, 6)
	appsOpenTest(t, params)
	//tagsTest(t, params, 8)
	appsOpenTest(t, params)
	utils.AppsDestroyTest(t, params)
}

func configSetup(t *testing.T) *utils.DeisTestConfig {
	cfg := utils.GetGlobalConfig()
	cfg.AppName = "configsample"
	utils.Execute(t, authLoginCmd, cfg, false, "")
	utils.Execute(t, gitCloneCmd, cfg, false, "")
	if err := utils.Chdir(cfg.ExampleApp); err != nil {
		t.Fatal(err)
	}
	utils.Execute(t, appsCreateCmd, cfg, false, "")
	// ensure envvars with spaces work fine on `git push`
	// https://github.com/deis/deis/issues/2477
	utils.Execute(t, configSet3Cmd, cfg, false, "the Deis team")
	// ensure custom buildpack URLS are in order
	utils.Execute(t, configSetBuildpackCmd, cfg, false, "https://github.com/heroku/heroku-buildpack-go#98f37cc")
	utils.Execute(t, gitPushCmd, cfg, false, "")
	utils.CurlApp(t, *cfg)
	utils.CheckList(t, "run env --app={{.AppName}}", cfg, "DEIS_APP", false)
	utils.CheckList(t, "run env --app={{.AppName}}", cfg, "DEIS_RELEASE", false)
	if err := utils.Chdir(".."); err != nil {
		t.Fatal(err)
	}
	return cfg
}

func configListTest(
	t *testing.T, params *utils.DeisTestConfig, notflag bool) {
	utils.CheckList(t, configListCmd, params, "FOO", notflag)
}

func configSetTest(t *testing.T, params *utils.DeisTestConfig) {
	utils.Execute(t, configSetCmd, params, false, "讲台")
	utils.CheckList(t, appsInfoCmd, params, "(v5)", false)
	utils.Execute(t, configSet2Cmd, params, false, "10")
	utils.CheckList(t, appsInfoCmd, params, "(v6)", false)
}

func configPushTest(t *testing.T, params *utils.DeisTestConfig) {
	if err := utils.Chdir(params.ExampleApp); err != nil {
		t.Fatal(err)
	}
	// create a .env in the project root
	if err := ioutil.WriteFile(".env", []byte("POWERED_BY=Deis"), 0664); err != nil {
		t.Fatal(err)
	}
	utils.Execute(t, "config:push --app {{.AppName}}", params, false, "Deis")
	utils.CheckList(t, appsInfoCmd, params, "(v7)", false)
	if err := utils.Chdir(".."); err != nil {
		t.Fatal(err)
	}
}

func configUnsetTest(t *testing.T, params *utils.DeisTestConfig) {
	utils.Execute(t, configUnsetCmd, params, false, "")
	utils.CheckList(t, appsInfoCmd, params, "(v8)", false)
	utils.CheckList(t, "run env --app={{.AppName}}", params, "FOO", true)
}
